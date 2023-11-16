#!/bin/bash
# Creates a new subdomain to be served by apache on the given domain
# Args [domain]
if [ -z "$1" ]
then
    echo "Error: missing domain argument"
    exit 1
fi

#error if not sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
domain=$1
source $SCRIPTS_DIR/_config.bash
echo "⚙️Creating page $domain..."

# Create www dir
mkdir -p $webRootDir
#only add group if it doesn't exist
if ! grep -q $domain /etc/group; then
    groupadd $domain
fi
chown daemon:$domain $siteRootDir -R
sudo chmod 770 $siteRootDir -R
sudo chmod g+s $siteRootDir -R

###################################################

sudo /opt/bitnami/ctlscript.sh stop apache   
sudo certbot certonly --standalone --preferred-challenges http -d $domain -m mika@klickstark.net -n --agree-tos
cert=/etc/letsencrypt/live/$domain/fullchain.pem
key=/etc/letsencrypt/live/$domain/privkey.pem

sshVhostConfig='

<IfModule !ssl_module>
  LoadModule ssl_module modules/mod_ssl.so
</IfModule>

<VirtualHost *:443>
  Options -Indexes +FollowSymLinks -MultiViews
  DocumentRoot '$webRootDir'
  ServerName '$domain'

  SSLEngine on
  SSLCertificateFile "'$cert'"
  SSLCertificateKeyFile "'$key'"

  <Directory "'$webRootDir'">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted

    Header set X-Robots-Tag "noindex, nofollow"
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
    AllowOverride All
    Require all granted

    Header set X-Robots-Tag \"noindex, nofollow\"


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

###################################################

echo "🔑 Creating database..."
source /home/bitnami/creds/mysql-admin.bash

#if /home/bitnami/creds/$domain.env already exists, exit
if ! [ -f "/home/bitnami/creds/$domain.env" ]; then 
  /opt/bitnami/mariadb/bin/mariadb -u $mysqlAdmin -p$mysqlPassword -e "CREATE DATABASE IF NOT EXISTS $devSubdomain;"
  echo "Creating database user"
  mysqlPass=$(openssl rand -base64 15)
  /opt/bitnami/mariadb/bin/mariadb -u $mysqlAdmin -p$mysqlPassword -e "CREATE USER IF NOT EXISTS '$devSubdomain'@'%' IDENTIFIED BY '$mysqlPass';"
  echo "
  WP_ENV=dev
  DB_HOST=localhost
  DB_NAME=$devSubdomain
  DB_USER=$devSubdomain
  DB_PASSWORD=$mysqlPass" >> /home/bitnami/creds/$domain.env

  echo "Granting privileges to user $domain on database '$domain'"
  /opt/bitnami/mariadb/bin/mariadb -u $mysqlAdmin -p$mysqlPassword -e "GRANT ALL PRIVILEGES ON $devSubdomain.* TO '$devSubdomain'@'%'; FLUSH PRIVILEGES;"
  echo "Done! Credentails are stored in /home/bitnami/creds/mysql-creds.bash"
  source $SCRIPTS_DIR/page/assign.bash $adminUser $domain
else
  echo "Database already exists. Skipping db & user creation. Credentials are in /home/bitnami/creds/$domain.env"
fi

echo "✔️ Done"

sudo /opt/bitnami/ctlscript.sh start apache
