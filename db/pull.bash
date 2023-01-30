#!/bin/bash
# Pulls the database from the production site and imports it into the local site, creating a db snapshot first
# Check if file .deploy exists 
if [ ! -f ".deploy" ]; then
    echo "❌ Cannot pull db: .deploy file not found in $PWD. Run setup-deployment.bash to create it"
    exit 1
fi


echo "⬆️ Creating snapshot of current database"
$(dirname "$0")/stash.bash "before-pull"
source .deploy
echo "⏬ Downloading database from $prodSiteUrl"
ssh $prodSiteSsh "cd $prodSiteWebRoot && wp db export - | gzip -9 > /tmp/$prodSiteUrl.sql.gz"
scp $prodSiteSsh:/tmp/db.sql.gz /tmp/db.sql.gz
ssh $prodSiteSsh "rm /tmp/$prodSiteUrl.sql.gz"
gunzip /tmp/$prodSiteUrl.sql.gz

echo "🔥 Deleting old database snapshots"
source local/db/delete-old-db-snapshots.bash

echo "⬇️ Importing database"
wp db import /tmp/$prodSiteUrl.sql

wp search-replace $prodSiteUrl $devSiteUrl

echo "🔑 Resetting user activation keys"
wp user update $(wp user list) --user_activation_key="" 

wp user create dev dev@dev.dev --role=administrator --user_pass=dev
echo "🔑 Added Dev User:"
echo "  Name: dev"
echo "  Pass: dev"
