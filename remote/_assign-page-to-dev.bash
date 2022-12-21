#!/bin/bash
### Assign
#create symlink in users home dir to www dir

username=$1
domain=$2

echo "⚙️Assigning $domain to user $username..."

source /home/bitnami/scripts/_env.bash

userhome=$(getent passwd $username | awk -F: '{print $6}')

#Add user to group for that domain
usermod -a -G $domain $username

#Create symlinks in users home dir
sudo su $username -c "ln -s $wwwDir $userhome"

## Creat symlink to configfile
###Create subfolder for domain
#mkdir $userhome/$domain
#set configFile "$vhostsDir$domain.conf"
#ln -s $configFile $userhome/$domain/vhost.conf

echo "Done ✔️"