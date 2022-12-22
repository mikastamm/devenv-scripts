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

curdir="$(dirname $0)"
domain=$1
echo "⚙️Creating page $domain..."

source $curdir/_env.bash
# Create www dir
mkdir -p $webRootDir
groupadd $domain
chown daemon:$domain $siteRootDir -R
sudo chmod 770 $siteRootDir -R

###################################################

sudo /opt/bitnami/ctlscript.sh stop apache   
sudo certbot certonly --standalone --preferred-challenges http -d $domain -m mika@klickstark.net -n --agree-tos
cert=/etc/letsencrypt/live/$domain/fullchain.pem
key=/etc/letsencrypt/live/$domain/privkey.pem

sshVhostConfig='

<IfModule !ssl_module>
  LoadModule ssl_module modules/mod_ssl.so
</IfModule>

Listen 443
SSLProtocol all -SSLv2 -SSLv3
SSLHonorCipherOrder on
SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !EDH !RC4"
SSLPassPhraseDialog  builtin
SSLSessionCache "shmcb:/opt/bitnami/apache/logs/ssl_scache(512000)"
SSLSessionCacheTimeout  300

<VirtualHost *:443>
  DocumentRoot '$webRootDir'
  ServerName '$domain'

  SSLEngine on
  SSLCertificateFile "'$cert'"
  SSLCertificateKeyFile "'$key'"

  <Directory "'$webRootDir'">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>

  # Error Documents
  ErrorDocument 503 /503.html
</VirtualHost>
'
sslConfigFile="$vhostsDir$domain-ssl.conf"
echo "$sshVhostConfig" > $sslConfigFile

###################################################

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

Include \"$(pwd)$sslConfigFile\"
"
configFile="$vhostsDir$domain.conf"
echo "$vhostConfig" > $configFile

###################################################




echo "✔️ Done"
source $curdir/_assign-page-to-dev.bash $adminUser $domain



sudo /opt/bitnami/ctlscript.sh start apache
