#!/bin/bash
# Stores a database snapshot of the current dev db. Can be restored using dev db restore
# [reason]
reason="$1"
snapshotDir=$siteRootDir/db-snapshots
mkdir -p $snapshotDir
nice -n 10 ionice -c2 -n 7 wp db export - --path=$webRootDir | gzip -9 > "$snapshotDir/$(date +%Y-%m-%d)-$reason.sql.gz"


