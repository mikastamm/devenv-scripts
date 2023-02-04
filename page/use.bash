#!/bin/bash
# Sets which site to target with the dev command
# Args: [path to site]

#if arg1 is empty exit ls /opt/bitnami/www
if [ -z "$1" ]; then
    echo "❌ Error: No site specified"
    echo "📁 Available sites:"
    ls /opt/bitnami/www
    exit 1
fi

pathToTry1=/opt/bitnami/www/$1.klickstark.net
pathToTry2=/opt/bitnami/www/$1
pathToTry3=$1

#if none of these exist exit with err
if [ ! -d "$pathToTry1" ] && [ ! -d "$pathToTry2" ] && [ ! -d "$pathToTry3" ]; then
    echo "❌ Error: $1 is not a valid site"
    exit 1
fi

#write the first path that exists to ~/.defaultpage
if [ -d "$pathToTry1" ]; then
    echo $pathToTry1 > ~/.defaultpage
elif [ -d "$pathToTry2" ]; then
    echo $pathToTry2 > ~/.defaultpage
elif [ -d "$pathToTry3" ]; then
    echo $pathToTry3 > ~/.defaultpage
fi

echo "Now using $1"
