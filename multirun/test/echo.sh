#!/usr/bin/env bash

# Helper script for generating output lines in a test command; prints its arguments, one per line.  Sleeps in between to
# make parallel tests' output more likely to be interleaved.

for a in "$@"; do echo "$a"; sleep 0.1; done
