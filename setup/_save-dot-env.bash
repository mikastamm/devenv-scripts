#!/bin/bash
#Saves current environment variables to .env file

devEnvContent="
KS_ENV=$KS_ENV
KS_DB_NAME=$KS_DB_NAME
KS_DB_USER=$KS_DB_USER
KS_DB_HOST=$KS_DB_HOST
KS_DB_PASSWORD=$KS_DB_PASSWORD
" 

echo "  💨 .env"
echo $devEnvContent > $webRootDir/.env