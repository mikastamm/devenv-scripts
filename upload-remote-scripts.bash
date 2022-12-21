#!/bin/bash

sshTarget=$1
dir=$(dirname $(status --current-filename))
echo $dir
# Check if the username or subdomain is empty
if test -z $sshTarget
then
    # Display an error message if either variable is empty
    echo "Error: sshtarget (arg 0) is required"
    # Exit the script with a non-zero exit status
    exit 1
fi

echo "Upload setup scripts (ssh)"
ssh $sshTarget "mkdir ~/scripts" 
scp -r $dir/remote/*.fish $sshTarget:~/scripts