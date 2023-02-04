# Wordpress Modifications

1. DB Connection Details are extracted into their own file: "wp-db-config.php", which is included in wpconfig

# File structure
The root of a projects website contains 
.
├── wp-cli.yml      
├── web             # Wordpress installation
│   └── wp-content, ...
├── prod.env        
├── dev.env         
├── db-snapshots    # db-snapshots made by the dev tools are stored here
└── .dev         # (Dev server only) SSH connection details of the prod server

## Deployment Setup
1. Location of the prod server is specified in the .dev file, rename .dev.example and fill it out. The file is created after running ``dev setup init-repo``
```
targetDirs=web/wp-content/plugins/XXX web/wp-content/themes/XXX web/wp-uploads/XXX
exclude=.env
prodSiteUrl=
prodSiteSsh=
prodSiteSshDir=
devSiteUrl=
```
2. Afterwards run ``dev deploy setup``, which helps you establish a connection to the production server, so you can deploy, and update your dev database