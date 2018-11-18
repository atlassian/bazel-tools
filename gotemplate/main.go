package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
	"text/template"

	"gopkg.in/yaml.v2"
)

func main() {
	var args arguments
	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "Usage: %s [options] [context_key:context_file ...]\n", os.Args[0])
		flag.PrintDefaults()
	}

	flag.StringVar(&args.templateFile, "t", "", "file to use for template")
	flag.StringVar(&args.outputFile, "o", "", "output to a file")
	flag.BoolVar(&args.executable, "e", false, "make file executable")
	flag.Parse()
	args.keyedContextFiles = flag.Args()
	if err := args.run(); err != nil {
		fmt.Fprintf(os.Stderr, "%+v\n", err)
		os.Exit(1)
	}
}

type arguments struct {
	templateFile      string
	keyedContextFiles []string
	outputFile        string
	executable        bool
}

func (a arguments) readContext() (map[string]interface{} /*context*/, error) {
	context := make(map[string]interface{}, len(a.keyedContextFiles))
	for _, keyedFile := range a.keyedContextFiles {
		parts := strings.SplitN(keyedFile, ":", 2)
		key := parts[0]
		file := parts[1]
		content, err := ioutil.ReadFile(file)
		if err != nil {
			return nil, fmt.Errorf("failed to read file %q: %v", file, err)
		}
		var value interface{}
		err = yaml.UnmarshalStrict(content, &value)
		if err != nil {
			return nil, fmt.Errorf("failed to unmarshal context from file %q: %v", file, err)
		}
		context[key] = value
	}
	return context, nil
}

func (a arguments) processTemplate(context map[string]interface{}) (finalError error) {
	closeWithError := func(c io.Closer) {
		if err := c.Close(); err != nil && finalError == nil {
			finalError = err
		}
	}

	data, err := ioutil.ReadFile(a.templateFile)
	if err != nil {
		return fmt.Errorf("failed to read template from %q: %v", a.templateFile, err)
	}

	out, err := os.Create(a.outputFile)
	if err != nil {
		return fmt.Errorf("failed to create output file %q: %v", a.outputFile, err)
	}
	defer closeWithError(out)

	tmpl, err := template.New("template").Parse(string(data))
	if err != nil {
		return fmt.Errorf("failed to parse template: %v", err)
	}

	err = tmpl.Execute(out, context)
	if err != nil {
		return fmt.Errorf("failed to execute template: %v", err)
	}
	return nil
}

func (a arguments) run() (finalError error) {
	context, err := a.readContext()
	if err != nil {
		return err
	}
	err = a.processTemplate(context)
	if err != nil {
		return err
	}
	if a.executable {
		err = os.Chmod(a.outputFile, 0755)
		if err != nil {
			return fmt.Errorf("failed to set executable bit on %q: %v", a.outputFile, err)
		}
	}
	return nil
}
