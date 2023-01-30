#!/bin/bash
# Deploys the database and media and plguin files to the prod environment. Use --full for a full deploy of all files
doNotCopy=.env

#Check if --full option is set
if [[ $1 == "--full" ]]; then
    #Check using ssh if the remote directory is empty
    #If not empty, print some of the files in it and ask confirmation (danger)
fi

