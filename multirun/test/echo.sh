#!/usr/bin/env bash

# Helper script for generating output lines in a test command; prints its arguments, one per line.

for a in "$@"; do echo "$a"; done
