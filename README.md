# devenv-scripts
## Overview

A collection of scripts for spinning up, managing and deploying local wordpress development pages using apache.

Note: I have since moved on to using [ddev](https://github.com/ddev/ddev) for these tasks, so this repository will not receive any updates.


## Available Commands
### Wordpress installations

`dev page create`: Creates a new page.

`dev page use`: Switches to use the specified page. Subsequent commands will use this page as a target

### Database Management

`dev db pull`: Retrieves the latest database state.

`dev db restore`: Restores the database from a snapshot.

`dev db stash`: Stores the current database state as a snapshot.


### Deployment Tools

`dev deploy both`: Deploys both database and files to the production server.

`dev deploy database`: Deploys only the database to the production server.

`dev deploy files`: Deploys only files to the production server.

`dev deploy setup`: Sets up the environment for deployment.

Note: SSH connection to the production Server has to be setup on your machine beforehand. 

### WordPress Configuration and Management

`dev wp cache`: Disables all cache plugins

`dev wp init`: Initializes a new WordPress setup. Sets up wp-cli and all necessary configuration files


## Setup
Configure `_config.bash` with your environment specifics

```
export adminUser="bitnami"
#Config files and metadata for each page are stored here
export siteRootDir="/opt/bitnami/www/$domain"
#eg. wndevel0
#The directory served by apache when visiting your subdomain 
export webRootDir="$siteRootDir/web"
...
```

## Deployment
Run `dev deploy setup` to start the guided setup process for ssh access to the production server.

### Manual Setup
Alternatively, you can specify the production server location in .dev (template available as .dev.example). Create this file by running dev setup init-repo.

Example .dev configuration:
```
targetDirs=web/wp-content/plugins/XXX web/wp-content/themes/XXX web/wp-uploads/XXX
useSymlinksForDeploy=true
exclude=.env
prodSiteUrl=
prodSiteSsh=
prodSiteSshDir=
devSiteUrl=
```

Run dev deploy setup to establish a connection with the production server for deployment and database updates.

# WordPress Modifications
To integrate with these scripts, WordPress connection details are stored in wp-db-config.php, located alongside wp-config.php. This file is automatically included in your WordPress configuration.

Important: Avoid redefining database connection details in the wp-config.php file.

