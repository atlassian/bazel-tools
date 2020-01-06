#!/usr/bin/env bash

# Helper script to spawn a command, sleep and then kill it.

echo "RAK>>running $1"
"$1" &
pid=$!
echo "RAK>>sleeping $2"
sleep "$2"
echo "RAK>>killing with signal $3"
kill -s "$3" "$pid"
wait "$pid"
echo "RAK>>done"
wait "$pid"
