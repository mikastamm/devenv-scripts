export vhostsDir="/opt/bitnami/apache/conf/vhosts/"
export adminUser="bitnami"
#eg. wndevel0.klickstark.net
export siteRootDir="/opt/bitnami/www/$domain"
#eg. wndevel0
export devSubdomain=$(echo $domain | sed 's/\..*//')
export webRootDir="$siteRootDir/web"
export snapshotDir="$siteRootDir/db-snapshots"