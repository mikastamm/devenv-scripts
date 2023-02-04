
#!/bin/bash
# Create persistent wp-config.php, that is tracked by git
saltsPhp=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

wpConfigTemplate=$(cat <<EOF
<?php
require_once __DIR__ . "/../load-env.php";

define( "WP_DEBUG", false );
define( "DB_CHARSET", "utf8" );
define( 'DB_COLLATE', '' );

define( "DB_NAME", \$_ENV['DB_NAME'] );
define( "DB_USER", \$_ENV['DB_USER'] );
define( "DB_PASSWORD", \$_ENV['DB_PASSWORD'] );
define( "DB_HOST", \$_ENV['DB_HOST'] );


\$table_prefix = "dBx_";

$saltsPhp

if ( ! defined( "ABSPATH" ) ) {
	define( "ABSPATH", __DIR__ . "/" );
}

require_once ABSPATH . "wp-settings.php";

EOF
)



echo "$wpConfigTemplate" > $webRootDir/wp-config.php
echo "$(cat $webRootDir/wp-config.php)"
echo "  💨 $webRootDir/wp-config.php"

