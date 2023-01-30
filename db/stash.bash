#!/bin/bash
# Stores a database snapshot of the current dev db. Can be restored using dev db restore
# [reason]
$reason=-$1
mkdir -p $snapshotDir
wp db export - | gzip -9 > $snapshotDir/${date +%Y-%m-%d}$reason.sql.gz
