#!/bin/bash
# Setup connection to the production site
read -p "➡️ Enter SSH Target (eg. user@0.0.0.0) for Production site (defaults to $prodSiteUrl): " prodSiteSsh
prodSiteSsh=${prodSiteSsh:-$prodSiteUrl}
read -p "➡️ Enter directory of Prod Site web dir: " export prodSiteWebRoot
read -p "➡️ Enter url of dev site: " devSiteUrl

# Create the config file
config_file="$(dirname "$0")/.deploy"
echo "💾 Creating config file at $config_file"
cat > "$config_file" <<EOF
prodSiteUrl=$prodSiteUrl
prodSiteSsh=$prodSiteSsh
prodSiteWebRoot=$prodSiteWebRoot
devSiteUrl=$devSiteUrl
EOF

#check if ~/.ssh/prod.pem exists
if [ -f ~/.ssh/prod.pem ]; then
    echo "🔑 Production key found"
else
    echo "🔑 Production key not found"
    echo "➡️ Enter path to production key"
    read prodKeyPath
    cp $prodKeyPath ~/.ssh/prod.pem
fi

#Create ssh config file from ssh string (eg. "user@host")
prodSiteSshUser=$(echo $prodSiteSsh | cut -d@ -f1)
prodSiteSshHost=$(echo $prodSiteSsh | cut -d@ -f2)
cat >> ~/.ssh/config <<EOF
Host $prodSiteSshHost
    HostName $prodSiteSshHost
    User $prodSiteSshUser
    IdentityFile ~/.ssh/prod.pem
EOF

source $(dirname($0))/_create-wp-config.bash
source $(dirname($0))/_create-wp-db-config.bash

echo "✅ Done, you can now ssh into $prodSiteSshHost"