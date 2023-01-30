#!/bin/bash
# Pulls the database from the production site and imports it into the local site, creating a db snapshot first
# Check if file .deploy exists 
if [ ! -f ".deploy" ]; then
    echo "❌ Cannot pull db: .deploy file not found in $PWD. Run setup-deployment.bash to create it"
    exit 1
fi

source .deploy
echo "⏬ Downloading database from $prodSiteUrl"
ssh $prodSiteSsh "cd $prodSiteWebRoot && wp db export - | gzip -9 > /tmp/$prodSiteUrl.sql.gz"
scp $prodSiteSsh:/tmp/db.sql.gz /tmp/db.sql.gz
ssh $prodSiteSsh "rm /tmp/$prodSiteUrl.sql.gz"
gunzip /tmp/$prodSiteUrl.sql.gz
echo "⬆️ Saving old database"
wp db export - | gzip -9 > db-snapshots/${date +%Y-%m-%d}.sql.gz
echo "🔥 Deleting old database snapshots"
source local/db/delete-old-db-snapshots.bash

echo "⬇️ Importing database"
wp db import /tmp/$prodSiteUrl.sql

wp search-replace $prodSiteUrl $devSiteUrl
wp option update blog_public 0
# if last command failed alert!
if [ $? -ne 0 ]; then
    echo "❌ Could not disable search engine indexing!!! Please do it manually! ❌"
    exit 1
fi