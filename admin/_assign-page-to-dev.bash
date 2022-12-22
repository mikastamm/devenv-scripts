#!/bin/bash
### Assign
#create symlink in users home dir to www dir

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Error: missing username or domain argument"
    exit 1
fi
curdir="$( dirname $0 )" 
username=$1
domain=$2

echo "⚙️Assigning $domain to user $username..."

source $curdir/_env.bash

userhome=$(getent passwd $username | awk -F: '{print $6}')

#Add user to group for that domain
usermod -a -G $domain $username

#Create symlinks in users home dir
sudo su $username -c "ln -s $siteRootDir $userhome"

## Creat symlink to configfile
###Create subfolder for domain
#mkdir $userhome/$domain
#set configFile "$vhostsDir$domain.conf"
#ln -s $configFile $userhome/$domain/vhost.conf

echo "Done ✔️"