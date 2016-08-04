<?php

define('WP_CACHE', true);
define('WP_DEBUG', false);
define('SAVEQUERIES', true);

/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */


ini_set('display_errors', '0');

// $db = getenv("CLEARDB_DATABASE_URL");
// $secretFile = '/etc/secrets/sql';
// if (file_exists($secretFile)) {
//     $db = file_get_contents($secretFile);
// }

// $wpSecrets = [];
// $wpSecretFile = '/etc/secrets/wpsecrets';
// if (file_exists($wpSecretFile)) {
//     $wpSecrets = json_decode(file_get_contents($wpSecretFile), true);
//     // error_log("We got data from /etc/secrets/wpsecrets");
// }


// $url = parse_url($db);
define("DB_NAME", getenv("WORDPRESS_DB_NAME"));
define("DB_USER", getenv("WORDPRESS_DB_USER"));
define("DB_PASSWORD", getenv("WORDPRESS_DB_PASSWORD"));
define("DB_HOST", getenv("WORDPRESS_DB_HOST"));


define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */


define( 'AUTH_KEY',         getenv('AUTH_KEY'));
define( 'SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY'));
define( 'LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY'));
define( 'NONCE_KEY',        getenv('NONCE_KEY'));
define( 'AUTH_SALT',        getenv('AUTH_SALT'));
define( 'SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT'));
define( 'LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT'));
define( 'NONCE_SALT',       getenv('NONCE_SALT'));



// define('AWS_ACCESS_KEY_ID',     $wpSecrets['AWS_S3_KEY']);
// define('AWS_SECRET_ACCESS_KEY', $wpSecrets['AWS_S3_SECRET']);



define('JETPACK_DEV_DEBUG', false);

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define ('WPLANG', 'nb_NO');


/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);


// echo "foo1<pre>";


// // // /** This should point to the app directory */
define("WP_SITEURL", "http://" . $_SERVER["HTTP_HOST"].'/');

// // // echo "\nWP_SITEURL " . WP_SITEURL;

// // // /** This is the URL your visitors will see */
define('WP_HOME', "http://" . $_SERVER["HTTP_HOST"]);

//  echo "\nWP_HOME " . WP_HOME ;
// * Point both directory and URLs to content/ instead of the default wp-content/ *
// if ( ! defined( 'WP_CONTENT_DIR' ) ) {
//     define( 'WP_CONTENT_DIR', __DIR__ . '/content' );
// }
// if ( ! defined( 'WP_CONTENT_URL' ) ) {
//     define( 'WP_CONTENT_URL', WP_HOME . '/content' );
// }
//  echo "\nWP_CONTENT_DIR " . WP_CONTENT_DIR;
//  echo "\nWP_CONTENT_URL " . WP_CONTENT_URL;
// echo "\nABSPATH " . ABSPATH;

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
// if ( !defined('ABSPATH') )
//    define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
