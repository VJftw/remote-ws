#!/usr/bin/env bash
# This script wraps apt-get allowing it to be used concurrently.
# From: https://askubuntu.com/a/375031
set -Eeuo pipefail

i=0
tput sc
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    case $(($i % 4)) in
        0 ) j="-" ;;
        1 ) j="\\" ;;
        2 ) j="|" ;;
        3 ) j="/" ;;
    esac
    tput rc
    echo -en "\r[$j] Waiting for other software managers to finish..." 
    sleep 0.5
    ((i=i+1))
done 

/usr/bin/apt-get "$@"
