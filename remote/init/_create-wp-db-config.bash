#!/bin/bash
#(Re)Create transient wp-database-config.php, that is NOT tracked by git

#source .env file if it exists
if [ -f .env ]; then
    echo "🔑 Loading .env file..."
    source .env
else
#Prompt for db credentials if .env file does not exist
    echo "🔑❓ .env file not found"
    echo "  ➡️ Enter database name:"
    read KS_DB_NAME
    echo "  ➡️ Enter database user:"
    read KS_DB_USER
    echo "  ➡️ Enter database password:"
    read KS_DB_PASSWORD
    echo "  ➡️ Enter database host:"
    read KS_DB_HOST
fi

wpDatabaseConfig = 
"<?php
/*-- THIS FILE IS GENERATED DO NOT EDIT        ----
---- EDIT DATABASE CREDENTIALS IN .env INSTEAD ----
---- EDIT wp-config in wp-config.php           --*/
define( 'DB_NAME', '$KS_DB_NAME' );
define( 'DB_USER', '$KS_DB_USER' );
define( 'DB_PASSWORD', '$KS_DB_PASSWORD' );
define( 'DB_HOST', '$KS_DB_HOST' );
"
echo "  💨 wp-database-config.php"
echo $wpDatabaseConfig > "$webRootDir/wp-database-config.php"

#wFvCF6z0Ce6b4zhm