#!/usr/bin/env bash

set -euo pipefail

rjsone_binary="$1"
shift
output="$1"
shift

"$rjsone_binary" "$@" > "$output"
