# remote-workstation

## Setting up access

1. Generate SSH key-pair
```
$ ssh-keygen -t ed25519 -C "$USER@$(HOSTNAME)"
```
2. Add ssh pubkey to to `main.tf`, `ssh_public_keys` in the `remote-ws-module`.
3. Create alias in `~/.ssh/config`
```
Host remote-ws
    HostName remote-ws.vjpatel.me
    User vjftw
```
