#!/bin/bash
# Deploys the database to the prod environment

#Remove dev user
echo "🗑️ Removing Dev User"
wp user delete dev --yes

echo "🔍 Replacing site url"
wp search-replace $devSiteUrl $prodSiteUrl

echo "Creating snapshot of prod database"