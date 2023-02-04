#!/bin/bash

#Checks if these variables are set
#prodSiteUrl
#prodSiteSsh
#prodSiteWebRoot

if [ -z "$prodSiteUrl" ]; then
    echo "❌prodSiteUrl is not set, please run 'devenv deploy setup' or edit the .dev file in you project root"
    exit 1
fi

if [ -z "$prodSiteSsh" ]; then
    echo "❌prodSiteSsh is not set, please run 'devenv deploy setup' or edit the .dev file in you project root"
    exit 1
fi

if [ -z "$prodSiteWebRoot" ]; then
    echo "❌prodSiteWebRoot is not set, please run 'devenv deploy setup' or edit the .dev file in you project root"
    exit 1
fi

#check if ~/.ssh/prod.pem exists
if ! [ -f ~/.ssh/prod.pem ]; then
    echo "❌ Production key not found at ~/.ssh/prod.pem"
    exit 1
fi

#check if prodSiteSsh is reachable
if ! ssh $prodSiteSsh "exit"; then
    echo "❌ $prodSiteSsh is not reachable"
    exit 1
fi

#check if prodSiteWebRoot exists on remote and contains a folder named web or is not empty
if ! ssh $prodSiteSsh "test -d $prodSiteWebRoot/web || test -n \"\$(ls -A $prodSiteWebRoot)\""; then
    echo "❌ $prodSiteWebRoot has no web directory and is not empty. prodSiteWebRoot should point to the web directory of the production site."
    exit 1
fi