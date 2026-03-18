#!/bin/bash

# Start SSH server in the background
sudo /usr/sbin/sshd

# Start code-server
exec /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8443 --auth password /home/coder/workspace
