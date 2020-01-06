package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

const (
	maxLineSize = 1 * 1024 * 1024
)

func main() {
	var args arguments
	flag.StringVar(&args.instructionsFile, "f", "", "file with instructions")
	flag.Parse()
	args.args = flag.Args()
	ctx, cancelFunc := context.WithCancel(context.Background())
	defer cancelFunc()
	cancelOnInterrupt(ctx, cancelFunc)
	exitCode, err := args.run(ctx)
	if err != nil {
		// Some sort of internal failure
		fmt.Fprintf(os.Stderr, "%+v\n", err)
		os.Exit(1)
	}
	if exitCode != 0 {
		// Some command failed. Don't print anything
		os.Exit(exitCode)
	}
}

type command struct {
	Tag string `json:"tag"`
	// path is the path of the program to execute.
	Path string `json:"path"`
}

type instructions struct {
	Commands []command `json:"commands"`
	Parallel bool      `json:"parallel"`
}

type arguments struct {
	instructionsFile string
	args             []string
}

func (a arguments) readInstructions() (instructions, error) {
	content, err := ioutil.ReadFile(a.instructionsFile)
	if err != nil {
		return instructions{}, fmt.Errorf("failed to read instructions file %q: %v", a.instructionsFile, err)
	}
	var instr instructions
	if err = json.Unmarshal(content, &instr); err != nil {
		return instructions{}, fmt.Errorf("failed to parse file %q as JSON: %v", a.instructionsFile, err)
	}
	return instr, nil
}

func (a arguments) run(ctx context.Context) (int, error) {
	instr, err := a.readInstructions()
	if err != nil {
		return 0, err
	}
	m := multirun{
		commands:   instr.Commands,
		stdoutSink: os.Stdout,
		stderrSink: os.Stderr,
		args:       a.args,
		parallel:   instr.Parallel,
	}
	err = m.run(ctx)
	if err != nil {
		var exitErr *exec.ExitError
		if errors.As(err, &exitErr) {
			return exitErr.ExitCode(), nil
		}
		return 0, err
	}
	return 0, nil
}

// cancelOnInterrupt calls f when os.Interrupt or SIGTERM is received.
// It ignores subsequent interrupts on purpose - program should exit correctly after the first signal.
func cancelOnInterrupt(ctx context.Context, f context.CancelFunc) {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		select {
		case <-ctx.Done():
		case <-c:
			f()
		}
	}()
}
