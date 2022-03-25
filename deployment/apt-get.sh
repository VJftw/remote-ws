#!/usr/bin/env bash
# This script wraps apt-get allowing it to be used concurrently.
# From: https://askubuntu.com/a/373478
set -Eeuo pipefail

while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock \
    >/dev/null 2>&1; do
   sleep 0.5
done

/usr/bin/apt-get "$@"
