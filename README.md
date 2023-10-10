# Docker Gitlab SSH Tunnel

## What is this?
These scripts are useful if you want to run Gitlab via Docker without splitting the ssh traffic between different ports. (Routing to your host ssh or into the Gitlab Docker container.)

Without this you'd need to give Gitlab a different ssh port as the default port 22, because the default port is mapped to your hosts sshd. Or the other way around.

If you want to use the default ports with both services, this is a solution.

## How is it working?

- If git communicates with a repo via ssh, it connects to the git user.

- This user exists on the host machine and an [AuthorizedKeysCommand](https://man.openbsd.org/sshd_config#AuthorizedKeysCommand) is configured in the sshd_config, so it runs the command to validate the authorized_keys.

- The authorized_keys.sh is linked here. This script outputs the authorized_keys from within the Gitlab Docker container, that gitlab uses to authorize its users.

- The command to the gitlab-shell is replaced on-the-fly to point to the tunnel.sh script from this repo.

- The tunnel.sh script tunnels the command through to the Gitlab Docker container to exactly that script, that we replaced from the command inside the authorized_keys.

## How can I use it?

1. Run the setup.sh script **as root** that creates a `git` system user automatically, adds the needed configuration into the `/etc/ssh/sshd_config` and sets a few rights to get the things working.

```bash
sudo ./setup.sh
```

2. I guess that's it...

