package main

import (
	"context"
	"fmt"
	"io"
)

type multirun struct {
	commands               []command
	stdoutSink, stderrSink io.Writer
	args                   []string
	parallel               bool
	quiet                  bool
}

func (m multirun) run(ctx context.Context) error {
	if m.parallel {
		errs := make(chan error)
		for _, cmd := range m.commands {
			p := process{
				tag:        cmd.Tag,
				path:       cmd.Path,
				stdoutSink: m.stdoutSink,
				stderrSink: m.stderrSink,
				args:       m.args,
				addTag:     true,
			}
			go func() {
				errs <- p.run(ctx)
			}()
		}
		var firstError error
		for range m.commands {
			if err := <-errs; firstError == nil {
				firstError = err
			}
		}
		return firstError
	} else {
		for _, cmd := range m.commands {
			p := process{
				tag:        cmd.Tag,
				path:       cmd.Path,
				stdoutSink: m.stdoutSink,
				stderrSink: m.stderrSink,
				args:       m.args,
			}
			if !m.quiet {
				fmt.Fprintf(m.stderrSink, "Running %s\n", cmd.Tag)
			}
			if err := p.run(ctx); err != nil {
				return err
			}
		}
	}
	return nil
}
