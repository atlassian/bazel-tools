package main

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha512"
	"errors"
	"flag"
	"fmt"
	"hash"
	"io"
	"io/ioutil"
	"os"
)

func main() {
	var args arguments
	flag.StringVar(&args.algorithm, "a", "sha256", "hashing algorithm to use")
	flag.StringVar(&args.outputFile, "o", "", "output result to a file")
	flag.BoolVar(&args.hex, "h", true, "output base-16 encoded bytes")
	flag.Parse()
	args.files = flag.Args()
	if err := args.run(); err != nil {
		fmt.Fprintf(os.Stderr, "%+v\n", err)
		os.Exit(1)
	}
}

type arguments struct {
	algorithm  string
	outputFile string
	files      []string
	hex        bool
}

func (a arguments) run() error {
	var h hash.Hash
	switch a.algorithm {
	case "md5":
		h = md5.New()
	case "sha1":
		h = sha1.New()
	case "sha256":
		h = sha256.New()
	case "sha512":
		h = sha512.New()
	default:
		return fmt.Errorf("unsupported hashing algorithm %q", a.algorithm)
	}

	first := true
	separator := []byte{0}
	for _, file := range a.files {
		if first {
			first = false
		} else {
			h.Write(separator) // ignore error. Hash.Write() promises to never return an error
		}
		err := hashFile(file, h)
		if err != nil {
			return fmt.Errorf("failed to hash file %s", file)
		}
	}

	result := h.Sum(nil)
	if a.hex {
		result = []byte(fmt.Sprintf("%x", result))
	}

	err := ioutil.WriteFile(a.outputFile, result, 0644)
	if err != nil {
		return fmt.Errorf("failed to save result in %s", a.outputFile)
	}
	return nil
}

func hashFile(file string, h hash.Hash) error {
	f, err := os.Open(file)
	if err != nil {
		return errors.New("failed to open file")
	}
	defer f.Close() // ignore errors from file opened for reading

	_, err = io.Copy(h, f)

	return err
}
