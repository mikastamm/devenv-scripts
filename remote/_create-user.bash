#!/bin/bash
# Creates the specified user
#
# Arguments:
# - username: the username to

if [ -z "$1" ] 
then
    echo "Error: missing username argument"
    exit 1
fi

username=$1
echo "⚙️Creating $username..."
source /home/bitnami/scripts/_env.bash

adduser --disabled-password --gecos "" $username

# Add admin user to the newly created users group
usermod -a -G $username $adminUser

# Add new user to remote-dev group
groupadd remote-dev
usermod -a -G remote-dev $username

#setup .ssh dir
mkdir -p /home/$username/.ssh
chmod 700 /home/$username/.ssh
chown $username:$username /home/$username/.ssh

# Give em fish shell
#chsh -s $(which fish) $username
echo "✔️ Done"