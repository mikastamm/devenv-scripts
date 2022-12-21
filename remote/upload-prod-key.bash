#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] 
then
    echo "Error: missing required argument(s). Usage: script.sh sshConnection privateKeyPath"
    exit 1
fi

sshConnection=$1
keyPath=$2

# Copy the private key to the working directory
cp $keyPath .
keyPath=$(basename $keyPath)
# Check if the private key is encrypted
if ssh-keygen -y -f $keyPath > /dev/null 2>&1
then
    # The key is not encrypted, ask the user for a password and encrypt the key
    echo "The provided key is not encrypted. Please enter a password to encrypt it:"
    read -s password
    ssh-keygen -p -f $keyPath -N $password
fi
# Upload the key to the specified ssh connection
scp $keyPath $sshConnection:~/.ssh/prod.pem
ssh $sshConnection "chmod 600 ~./.ssh/prod.pem"
rm $keyPath