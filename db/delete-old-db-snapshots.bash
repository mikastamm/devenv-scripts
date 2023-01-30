#!/bin/bash
# Deletes all but the 5 most recent database snapshots (eg. from dev db stash or deployment operations)

# Store the current working directory
cwd=$(pwd)


#exit if directory does not exist
if [ ! -d "./db-snapshots" ]; then
    exit 1
fi
# Change to the db-snapshots directory
cd ./db-snapshots

# Find all of the files in the current directory, sorted by modification time (newest first)
files=$(find . -maxdepth 1 -type f -printf '%T@ %p\n' | sort -n | cut -f2- -d" ")

# Count the number of files
file_count=$(echo "$files" | grep ".sql" | wc -l)

# If there are more than 5 files
if [ "$file_count" -gt 10 ]; then
  # Delete all but the first 5 files
  echo "$files" | tac | grep ".sql" | tail -n +5 | xargs rm
fi

# Change back to the original working directory
cd "$cwd"