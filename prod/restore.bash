#!/bin/bash
# Restores the database from the given snapshot, or the latest snapshot if none is given
# Args: [snapshot name]
snapshotName=$1


ssh $prodSiteSsh "cd $prodSiteWebRoot && gunzip $snapshotDir/$snapshotName.sql.gz --stdout | wp db import -"
echo "📦 Restored snapshot of production database from remote $snapshotDir/$snapshotName.sql.gz"