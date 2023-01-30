# Wordpress Modifications

1. DB Connection Details are extracted into their own file: "wp-db-config.php", which is included in wpconfig


# Deployment
1. Location of the prod server is specified in the .deploy file:
```
prodSiteUrl=$prodSiteUrl
prodSiteSsh=$prodSiteSsh
prodSiteWebRoot=$prodSiteWebRoot
devSiteUrl=$devSiteUrl
```