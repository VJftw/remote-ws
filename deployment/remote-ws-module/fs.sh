#!/usr/bin/env bash
# This script configures the filesystem for various things that need a bigger than /root filesystem.
set -Eeuo pipefail


# docker
mkdir -p /etc/docker/
cat <<EOF > /etc/docker/daemon.json
{
  "data-root": "/home/lib/_docker"
}
EOF
