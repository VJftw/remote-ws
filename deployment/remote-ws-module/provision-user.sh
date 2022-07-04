#!/usr/bin/env bash
# This script provisions a user's home directory with the given SSH keys
set -Eeuo pipefail

username="$1"
ssh_public_keys_b64="$2"

main() {
  ensureHomeVolumeMount
  ensureUser "$username"

  mapfile -t ssh_public_keys < \
    <(echo "$ssh_public_keys_b64" | base64 -d)
  configureSSHAuthorizedKeys "$username" "${ssh_public_keys[@]}"
}

ensureUser() {
  local username
  username="$1"
  if grep "$username" /etc/passwd; then
    # if the user already exists, do nothing
    return
  fi

  # add the user
  adduser --disabled-password --gecos "" "$username"

  # add user to sudoers with no password requirements.
  usermod -aG sudo "$username"
  echo "" >> /etc/sudoers
  echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
}

configureSSHAuthorizedKeys() {
  local username
  username="$1"
  local shh_public_keys
  ssh_public_keys=("${@:2}")

  # remove existing if it exists
  rm -f "/home/$username/.ssh/authorized_keys"
  # ensure ~/.ssh exists
  mkdir -p "/home/$username/.ssh"
  for ssh_pub in "${ssh_public_keys[@]}"; do
    echo "$ssh_pub" >> "/home/$username/.ssh/authorized_keys"
  done
  chmod 0600 "/home/$username/.ssh/authorized_keys"
  chown -R $username:$username "/home/$username/"
}

ensureHomeVolumeMount() {
  if grep "on /home" /proc/mounts; then
    # if /home is already mounted, do nothing
    return
  fi

  local disk_name
  disk_name="home"
  local disk_path
  disk_path="/dev/disk/by-id/google-${disk_name}"

  if [ "$(lsblk -o fstype,serial | grep "$disk_name" | awk '{ print $1 }')" != "ext4" ]; then
    # format the disk if it is not ext4
    mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard "$disk_path"
  fi

  # disk mount does not exist, *attempt* to mount the disk
  mount -o discard,defaults "$disk_path" /home/ || true
  if ! grep "/home" /etc/fstab; then
    echo "$disk_path /home ext4 discard,defaults,nofail 0 2" >> /etc/fstab
  fi
}

main
