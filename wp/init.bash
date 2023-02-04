#!/bin/bash
#Inititalized the wordpress installation on the dev machine and creates the repository on github
#args [prodSiteUrl] [siteRootDir]
echo "➡️Enter the URL that will be of the production site: (eg. mysite.klickstark.net)"
read prodSiteUrl
echo "➡️Enter the directory where you want to clone the repository: ($(pwd))"
read siteRootDir 
siteRootDir=${siteRootDir:-$PWD}

#It is assumed that the dirname is the same as the dev url
domain=$(basename $siteRootDir)
source $SCRIPTS_DIR/_env.bash
  # cd to siteRootDir and create a new repository using the specified template
echo "📁 Changing to $siteRootDir directory..."
cd "$siteRootDir"
echo "🆕 Creating repository Klickstark/$prodSiteUrl..."

if ! gh repo list Klickstark --json name --jq ".[] | select(.name == \"$prodSiteUrl\")" | grep -q "$prodSiteUrl"; then 
  gh repo create "Klickstark/$prodSiteUrl" --private --template "https://github.com/Klickstark/wp-template.git"
fi

if [ -d "$siteRootDir/web" ] && [ -z "$(ls -A $siteRootDir/web)" ]; then
    rm -rf "$siteRootDir/web"
fi

git clone "https://github.com/Klickstark/shap3s.com" "$siteRootDir"

source $SCRIPTS_DIR/setup/_import-dot-env.bash

echo "💾 Creating config files..."

source $SCRIPTS_DIR/setup/_init-wordpress.bash
source $SCRIPTS_DIR/setup/create-wp-config.bash

#

#ask wether the user wants to setup deployment, and execute deploy/setup-deployment.bash if yes
read -p "🚀 Do you want to setup deployment? (y/n): " setupDeployment
if [ "$setupDeployment" = "y" ]; then
    source $SCRIPTS_DIR/deploy/setup.bash
fi