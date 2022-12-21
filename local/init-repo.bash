#!/bin/bash
#Inititalized the repo on the dev machine

echo "➡️Enter the URL that will be of the production site:"
read prodSiteUrl
echo "➡️Enter the directory where you want to clone the repository: ($(pwd))))"
read wwwDir 
wwwDir = ${wwwDir:-$PWD}

  # cd to wwwDir and create a new repository using the specified template
echo "📁 Changing to $wwwDir directory..."
cd "$wwwDir"
echo "🆕 Creating repository Klickstark/$prodSiteUrl..."
gh repo create "Klickstark/$prodSiteUrl" --private --clone --template "https://github.com/Klickstark/wp-template.git"

#Set .env variables for dev environment
KS_ENV=dev
KS_DB_NAME=$(whoami)
KS_DB_USER=penguind
KS_DB_HOST=localhost
KS_DB_PASSWORD=2!Rj^KTrjB62vNXd
echo "💾 Creating config files..."
source $(dirname $0)/init/_save-dot-env.bash
source $(dirname $0)/init/_init-wordpress.bash
source $(dirname $0)/init/_create-wp-db-config.bash
source $(dirname $0)/init/_create-wp-config.bash

#

#ask wether the user wants to setup deployment, and execute deploy/setup-deployment.bash if yes
read -p "🚀 Do you want to setup deployment? (y/n): " setupDeployment
if [ "$setupDeployment" = "y" ]; then
    source $(dirname $0)/deploy/setup-deployment.bash
fi