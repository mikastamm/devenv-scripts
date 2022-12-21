#!/bin/bash
ssh prodSiteSsh "cd $prodSiteSshDir && wp db export - | gzip -9 > ../tmp/db.sql.gz"
scp prodSiteSsh:$prodSiteSshDir/tmp/db.sql.gz tmp/db.sql.gz