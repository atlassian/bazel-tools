#!/usr/bin/env bash

# Test harness.  Runs the command `$1`, checking that it exits with code `$2` and its stdout output matches the content
# of `$3`.  Exits 0 if all is matching, non-0 otherwise.

ACTUAL_STDOUT=$($1)
ACTUAL_CODE=$?
EXPECTED_CODE=$2
EXPECTED_STDOUT=$(cat "$3")

if [[ "$ACTUAL_STDOUT" == "$EXPECTED_STDOUT" ]] && [[ "$ACTUAL_CODE" -eq "$EXPECTED_CODE" ]]
then
    echo "match"
    exit 0
else
    echo "mismatch"
    echo "expected code $EXPECTED_CODE, stdout:"
    echo "$EXPECTED_STDOUT"
    echo
    echo "actual code $ACTUAL_CODE, stdout:"
    echo "$ACTUAL_STDOUT"
    exit 1
fi
