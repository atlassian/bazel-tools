#!/usr/bin/env bash

# Test harness.  Runs the command `$1`, checking that it exits with code `$2` and its stdout output matches the content
# of `$3`.  Exits 0 if all is matching, non-0 otherwise.

set -o pipefail

# Use `eval` instead of just `$($1)` to allow the command to include
# pipelines.
ACTUAL_OUT=$(eval "$1" 2>&1)
ACTUAL_CODE=$?
EXPECTED_CODE=$2
EXPECTED_OUT=$(cat "$3")

if [[ "$ACTUAL_OUT" == "$EXPECTED_OUT" ]] && [[ "$ACTUAL_CODE" -eq "$EXPECTED_CODE" ]]
then
    echo "match"
    exit 0
else
    echo "mismatch"
    echo "expected code $EXPECTED_CODE, stdout:"
    echo "$EXPECTED_OUT"
    echo
    echo "actual code $ACTUAL_CODE, stdout:"
    echo "$ACTUAL_OUT"
    exit 1
fi
