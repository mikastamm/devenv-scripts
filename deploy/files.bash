#!/bin/bash
# Deploys files to the prod environment

if [ -z $prodSiteUrl]; then
    echo "❌ Cannot deploy files: $prodSiteUrl is not set, please run 'devenv deploy setup' or edit the .dev file in you project root"
    exit 1
fi

echo "📦 Uploading files to $devSiteUrl"
# Print all entries of $targetDirs
for targetDir in "${targetDirs[@]}"
do
    echo "📦 Uploading files to $targetDir"
done
