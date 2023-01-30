
#!/bin/bash
# Create persistent wp-config.php, that is tracked by git
saltsPhp=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

wpConfigTemplate=
"
<?php

/* DB Connection Details live in wp-database-config.php */

$saltsPhp

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
/** Loads db connection & salts */
require_once ABSPATH . 'wp-database-config.php';

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
"

echo "  💨 wp-config.php"
echo $wpConfigTemplate > "$webRpptDir/wp-config.php"


