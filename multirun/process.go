package main

import (
	"bufio"
	"context"
	"fmt"
	"io"
	"os/exec"
	"sync"
	"syscall"
)

// process represents a single process that needs to be run.
type process struct {
	tag string
	// path is the path of the program to execute.
	path                   string
	stdoutSink, stderrSink io.Writer
	args                   []string
	// addTag specifies whether a tag should be prepended to each line on the stdin/stderr from the command.
	addTag bool
}

func (p *process) run(ctx context.Context) error {
	cmd := &exec.Cmd{
		Path: p.path,
		Args: append([]string{p.path}, p.args...),
		// nil means "use environment of the parent process", see the godoc. We do this explicitly to show the intent.
		Env: nil,
	}
	var stdout, stderr io.ReadCloser
	if p.addTag {
		var err error
		stdout, err = cmd.StdoutPipe()
		if err != nil {
			return fmt.Errorf("failed to get stdout pipe for %q: %v", p.path, err)
		}
		stderr, err = cmd.StderrPipe()
		if err != nil {
			return fmt.Errorf("failed to get stderr pipe for %q: %v", p.path, err)
		}
	} else {
		cmd.Stdout = p.stdoutSink
		cmd.Stderr = p.stderrSink
	}
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("failed to start process for %q: %v", p.path, err)
	}
	var wg sync.WaitGroup
	if p.addTag {
		wg.Add(2)
		go func() {
			defer wg.Done()
			p.readLinesAndAddPrefix(stdout, p.stdoutSink)
		}()
		go func() {
			defer wg.Done()
			p.readLinesAndAddPrefix(stderr, p.stderrSink)
		}()
	}
	var wg2 sync.WaitGroup
	defer wg2.Wait() // waiting for terminating go-routine to finish
	done := make(chan struct{})
	defer close(done)
	wg2.Add(1)
	go func() {
		defer wg2.Done()
		select {
		case <-ctx.Done(): // process should be terminated earlier
			if err := cmd.Process.Signal(syscall.SIGTERM); err != nil && !isFinished(err) {
				_, _ = fmt.Fprintf(p.stderrSink, "[multirun:%s] Failed to send SIGTERM, sending SIGKILL\n", p.tag)
				if err = cmd.Process.Kill(); err != nil && !isFinished(err) {
					_, _ = fmt.Fprintf(p.stderrSink, "[multirun:%s] Failed to send SIGKILL\n", p.tag)
				}
			}
		case <-done:
			// Nothing to do - process finished
		}
	}()
	wg.Wait() // waiting for stderr/stdout to be fully consumed before calling cmd.Wait() as per os/exec.Cmd documentation
	return cmd.Wait()
}

func isFinished(err error) bool {
	return err.Error() == "os: process already finished"
}

func (p *process) readLinesAndAddPrefix(in io.Reader, out io.Writer) {
	s := bufio.NewScanner(in)
	s.Buffer(make([]byte, 0, maxLineSize), maxLineSize)
	for s.Scan() {
		// ignore errors
		_, _ = fmt.Fprintf(out, "[%s] %s\n", p.tag, s.Bytes())
	}
	if err := s.Err(); err != nil {
		_, _ = fmt.Fprintf(p.stderrSink, "[multirun:%s] Read failed: %v\n", p.tag, err)
	}
}
