#!/bin/bash
# This script generates an SSH key for the given username and domain, and adds a configuration entry to the user's 
# ~/.ssh/config file for connecting to a server using the generated key.
#
# Arguments:
#   $1 - The username to use for the SSH key
#   $2 - The domain to use for the SSH key
#   $3 - The IP address of the server to connect to

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
    echo "Error: missing required argument(s). Usage: configure-user.sh username domain ssh_ip"
    exit 1
fi

username=$1
domain=$2
sshIp=$3
mkdir ~/.ssh/klickstark-dev/ &> /dev/null
if test -e ~/.ssh/klickstark-dev/$username
then
    if test -e ~/.ssh/klickstark-dev/$username.pub
    then
        echo "SSH Key for $username already exists, using existing"
    else
        # The SSH key file exists, so exit with an error
        echo "Error: SSH key file for $username already exists, but no pubkey found!"
        exit 1
    fi
else
    # Generate ssh-key and put it in ~/.ssh
    echo "Generating ssh key for $username@$domain..."
    ssh-keygen -t rsa -b 4096 -C "$username@$domain" -f ~/.ssh/klickstark-dev/$username
    chmod 600 ~/.ssh/klickstark-dev/$username
fi

# Load public key of generated key into $publicKey
publicKey=$(cat ~/.ssh/klickstark-dev/$username.pub)
echo "Generated $publicKey"

# Add ssh config to ~/.ssh/config ()
echo "Updating ssh config.."
config="
Host $username
	User $username
    HostName $sshIp
    IdentityFile ~/.ssh/klickstark-dev/$username
"
echo "$config" >> ~/.ssh/config