#!/bin/bash
# Pulls the database from the production site and imports it into the local site, creating a db snapshot first
# Check if file .dev exists in the page root directory 
if [ -z "$prodSiteUrl" ]; then
    echo "❌ Cannot deploy files: $prodSiteUrl is not set, please run 'devenv deploy setup' or edit the .dev file in you project root"
    exit 1
fi
set -e

echo "⬆️ Creating snapshot of current database"
source $SCRIPTS_DIR/db/stash.bash "before-pull"
echo "⏬ Downloading database from $prodSiteUrl"
ssh $prodSiteSsh "cd $prodSiteWebRoot && wp db export /tmp/db.sql && gzip -9 -f /tmp/db.sql > /tmp/db.sql.gz"
scp $prodSiteSsh:/tmp/db.sql.gz /tmp/db.sql.gz
echo "⬇️ Importing database"
gunzip /tmp/db.sql.gz --stdout | wp db import - --path=$webRootDir

echo "🔥 Deleting old database snapshots"
source $SCRIPTS_DIR/db/delete-old-db-snapshots.bash


wp search-replace $prodSiteUrl $devSiteUrl

echo "🔑 Resetting user activation keys"
wp user update $(wp user list) --user_activation_key="" 

wp user create dev dev@dev.dev --role=administrator --user_pass=dev
echo "🔑 Added Dev User:"
echo "  Name: dev"
echo "  Pass: dev"
