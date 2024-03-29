#!/bin/bash
# Assign the page to a user, allowing them to edit it
#create symlink in users home dir to www dir

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Error: missing username or domain argument"
    exit 1
fi
username=$1
domain=$2

echo "⚙️Assigning $domain to user $username..."

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

echo "Set as default page? (y/n)"
read default
if [ "$default" == "y" ] || [ "$default" == "yes" ]
then
    echo $siteRootDir > $userhome/.defaultpage
fi


if [ -f /home/$username/creds/mysql-creds.bash ]
then
    source /home/$username/creds/mysql-creds.bash
fi

# Technically this only needs to run once, but it's idempotent so it's fine
sudo setfacl -R -m g:remote-dev:rX /etc/letsencrypt/{live,archive}/shap3sdevel0.klickstark.net
sudo setfacl -m g:remote-dev:rX /etc/letsencrypt/{live,archive}/ 

echo "Done ✔️"

