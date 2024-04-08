#!/bin/bash

# Adjust permissions on /var/run/docker.sock
if [ -S /var/run/docker.sock ]; then
    sudo chown root:docker /var/run/docker.sock
    sudo chmod 660 /var/run/docker.sock
fi

# Execute the passed command
exec "$@"