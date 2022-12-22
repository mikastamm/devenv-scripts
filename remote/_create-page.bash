#!/bin/bash

# Creates a new subdomain to be served by apache on the given domain
#
# Arguments:
# - domain: the domain to create the subdomain for

if [ -z "$1" ]
then
    echo "Error: missing domain argument"
    exit 1
fi

domain=$1
echo "⚙️Creating page $domain..."

source /home/bitnami/scripts/_env.bash
# Create www dir
mkdir -p $webRootDir
groupadd $domain
chown daemon:$domain $siteRootDir
sudo chmod 770 $siteRootDir

vhostConfig="
<VirtualHost *:80>
  ServerName $domain
  DocumentRoot $webRootDir
<Directory \"$webRootDir\">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride None
    Require all granted

    # Do not serve .* directories
    RedirectMatch 404 /\\.

    RewriteEngine On
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
    RewriteBase /
    RewriteRule ^index\\.php\\$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
    # END WordPress
  </Directory>
</VirtualHost>
"
configFile="$vhostsDir$domain.conf"
echo "$vhostConfig" > $configFile
echo "✔️ Done"
source /home/$adminUser/scripts/_assign-page-to-dev.bash $adminUser $domain