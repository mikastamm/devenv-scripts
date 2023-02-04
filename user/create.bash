#!/bin/bash
# Creates the specified user on the dev server
#
# Arguments:
# - username: the username to

if [ -z "$1" ] 
then
    echo "Error: missing username argument"
    exit 1
fi

#error if not sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

username=$1
echo "⚙️Creating $username..."

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

sudo su $username -c "$SCRIPTS_DIR/user/_install-nvm.bash"

echo "✔️ Done"