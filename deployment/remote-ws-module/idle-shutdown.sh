#!/usr/bin/env bash
# This script shuts down the machine if it has no SSH connections for over 15 minutes.
set -Eeuo pipefail

INITIAL_DELAY=600
INTERVAL=900

if ! command -v netstat &> /dev/null; then
  apt-get update
  apt-get install -y net-tools
fi

sleep "$INITIAL_DELAY"

while [ 1 ]; do
  if ! netstat | grep ssh | grep ESTABLISHED; then
    shutdown -h now
  fi
  echo "-> sleeping for ${INTERVAL}s"
  sleep "$INTERVAL"
done
