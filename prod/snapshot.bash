#!/bin/bash
# Saves a snapshot of the production database
# Args: [snapshot reason]
snapshotReason=-$1
if [ -z "$snapshotDir" ]; then
    echo "❌snapshotDir is not set"
    exit 1
fi
ssh $prodSiteSsh "cd $prodSiteWebRoot && wp db export - | gzip -9" > $snapshotDir/${date +%Y-%m-%d}$snapshotReason.sql.gz
echo "📦 Saved snapshot of production database to remote $snapshotDir/${date +%Y-%m-%d}$snapshotReason.sql.gz"