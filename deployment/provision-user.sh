#!/usr/bin/env bash
# This script provisions a user's home directory with the given SSH keys
set -Eeuo pipefail

user="vjftw"
ssh_pubs=(
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAd2c9cCa12ozaNjeEjTShxj92oMyiwiiIQ+5buXj2D vj@SIRIUS"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9RT6lp86XpwrC8R7jFfnm3DV+PAVNP2Rbt7YjX6tJE vj@DUMBLEDORE"
)

function createUser {
  adduser --disabled-password --gecos "" "$user"
  usermod -aG sudo "$user"
  echo "" >> /etc/sudoers
  echo "$user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
}

function configureSSHAuthorizedKeys {
  # remove existing if it exists
  rm -f "/home/$user/.ssh/authorized_keys"
  # ensure ~/.ssh exists
  mkdir -p "/home/$user/.ssh"
  for ssh_pub in "${ssh_pubs[@]}"; do
    echo "$ssh_pub" >> "/home/$user/.ssh/authorized_keys"
  done
  chmod 0600 "/home/$user/.ssh/authorized_keys"
  chown -R $user:$user "/home/$user/"
}

if ! grep "on /home" /proc/mounts; then
  disk_name="home"
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
fi

if ! grep "$user" /etc/passwd; then
  # user does not exist, create them
  createUser
fi


configureSSHAuthorizedKeys
