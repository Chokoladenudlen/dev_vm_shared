#!/bin/bash

# Parameters:
# 1: user
# 2: ssh key filename

set -xe

MIG=${1:-$USER}
KEY=$2

mv /tmp/$KEY /home/$MIG/.ssh/$KEY
chown $MIG:$MIG /home/$MIG/.ssh/$KEY
chmod 600 /home/$MIG/.ssh/$KEY