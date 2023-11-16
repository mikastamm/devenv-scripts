export vhostsDir="/opt/bitnami/apache/conf/vhosts/"
export adminUser="bitnami"
#Config files and metadata for each page are stored here
export siteRootDir="/opt/bitnami/www/$domain"
#eg. wndevel0
export devSubdomain=$(echo $domain | sed 's/\..*//')
#The directory served by apache when visiting your subdomain 
export webRootDir="$siteRootDir/web"
#Where to store db snapshots
export snapshotDir="$siteRootDir/db-snapshots"