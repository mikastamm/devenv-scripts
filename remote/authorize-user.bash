#!/bin/bash
# This script loads the public key for the given username from the ~/.ssh directory, and adds it to the authorized_keys file for the specified user
# on the server specified by the sshTarget variable.
#
# Arguments:
#   $1 - The username for which to load the public key
#   $2 - The server on which to authorize the given user

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Error: missing required argument. Usage: script.sh username sshTarget"
    exit 1
fi

username=$1
sshTarget=$2 

echo "Loading public key from ~/.ssh/klickstark-dev/$username.pub..."
pubkey=$(cat ~/.ssh/klickstark-dev/$username.pub)
#authorize the provided key
ssh $sshTarget "userhome=$(getent passwd $username | awk -F: '{print \$6}') && echo \"$pubkey\" >> \$userhome/.ssh/authorized_keys"