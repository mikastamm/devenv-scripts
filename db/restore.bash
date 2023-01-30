#/bin/bash
# restores the database from the latest snapshot
# Args: [snapshot name] 
$snapshotName=$1
gunzip $snapshotDir/$snapshotName.sql.gz --stdout | wp db import -
