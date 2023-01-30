#!/bin/bash
# Clones a repository from github into the specified directory
echo "➡️Enter the URL of the production site:"
read prodSiteUrl
echo "➡️Enter the directory where you want to clone the repository:"
read siteRootDir
webRootDir="$siteRootDir/web"
# Check if a repository with the name of prodSiteUrl already exists
if gh repo list Klickstark --json name --jq ".[] | select(.name == \"$prodSiteUrl\")" | grep -q "$prodSiteUrl"; then
    repoName=$prodSiteUrl
else
    read -p "🆕 Whats the name of the repository?: Klickstark/" repoName
fi

  # Clone the repository into siteRootDir
  echo "🔍 Repository found, cloning into $siteRootDir..."
  git clone "https://github.com/Klickstark/$repoName.git" "$siteRootDir"



