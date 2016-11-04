<?php
/**
 * WordPress Installer
 *
 * @package WordPress
 * @subpackage Administration
 */

// Sanity check.
if ( false ) {
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Error: PHP is not running</title>
</head>
<body class="wp-core-ui">
	<p id="logo"><a href="https://wordpress.org/">WordPress</a></p>
	<h1>Error: PHP is not running</h1>
	<p>WordPress requires that your web server is running PHP. Your server does not have PHP installed, or PHP is turned off.</p>
</body>
</html>
<?php
}

/**
 * We are installing WordPress.
 *
 * @since 1.5.1
 * @var bool
 */
define( 'WP_INSTALLING', true );

/** Load WordPress Bootstrap */
require_once( dirname( dirname( __FILE__ ) ) . '/wp-load.php' );

/** Load WordPress Administration Upgrade API */
require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );

/** Load WordPress Translation Install API */
require_once( ABSPATH . 'wp-admin/includes/translation-install.php' );

/** Load wpdb */
require_once( ABSPATH . WPINC . '/wp-db.php' );

nocache_headers();

$step = isset( $_GET['step'] ) ? (int) $_GET['step'] : 0;

/**
 * Display install header.
 *
 * @since 2.5.0
 *
 * @param string $body_classes
 */
function display_header( $body_classes = '' ) {
	header( 'Content-Type: text/html; charset=utf-8' );
	if ( is_rtl() ) {
		$body_classes .= 'rtl';
	}
	if ( $body_classes ) {
		$body_classes = ' ' . $body_classes;
	}
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>
<head>
	<meta name="viewport" content="width=device-width" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex,nofollow" />
	<title><?php _e( 'WordPress &rsaquo; Installation' ); ?></title>
	<?php
		wp_admin_css( 'install', true );
		wp_admin_css( 'dashicons', true );
	?>
</head>
<body class="wp-core-ui<?php echo $body_classes ?>">
<p id="logo"><a href="<?php echo esc_url( __( 'https://wordpress.org/' ) ); ?>" tabindex="-1"><?php _e( 'WordPress' ); ?></a></p>

<?php
} // end display_header()

/**
 * Display installer setup form.
 *
 * @since 2.8.0
 *
 * @param string|null $error
 */

// Let's check to make sure WP isn't already installed.
if ( is_blog_installed() ) {
	display_header();
	die(
		'<h1>' . __( 'Already Installed' ) . '</h1>' .
		'<p>' . __( 'You appear to have already installed WordPress. To reinstall please clear your old database tables first.' ) . '</p>' .
		'<p class="step"><a href="' . esc_url( wp_login_url() ) . '" class="button button-large">' . __( 'Log In' ) . '</a></p>' .
		'</body></html>'
	);
}

/**
 * @global string $wp_version
 * @global string $required_php_version
 * @global string $required_mysql_version
 * @global wpdb   $wpdb
 */
global $wp_version, $required_php_version, $required_mysql_version;

$php_version    = phpversion();
$mysql_version  = $wpdb->db_version();
$php_compat     = version_compare( $php_version, $required_php_version, '>=' );
$mysql_compat   = version_compare( $mysql_version, $required_mysql_version, '>=' ) || file_exists( WP_CONTENT_DIR . '/db.php' );

if ( !$mysql_compat && !$php_compat )
	$compat = sprintf( __( 'You cannot install because <a href="https://codex.wordpress.org/Version_%1$s">WordPress %1$s</a> requires PHP version %2$s or higher and MySQL version %3$s or higher. You are running PHP version %4$s and MySQL version %5$s.' ), $wp_version, $required_php_version, $required_mysql_version, $php_version, $mysql_version );
elseif ( !$php_compat )
	$compat = sprintf( __( 'You cannot install because <a href="https://codex.wordpress.org/Version_%1$s">WordPress %1$s</a> requires PHP version %2$s or higher. You are running version %3$s.' ), $wp_version, $required_php_version, $php_version );
elseif ( !$mysql_compat )
	$compat = sprintf( __( 'You cannot install because <a href="https://codex.wordpress.org/Version_%1$s">WordPress %1$s</a> requires MySQL version %2$s or higher. You are running version %3$s.' ), $wp_version, $required_mysql_version, $mysql_version );

if ( !$mysql_compat || !$php_compat ) {
	display_header();
	die( '<h1>' . __( 'Insufficient Requirements' ) . '</h1><p>' . $compat . '</p></body></html>' );
}

if ( ! is_string( $wpdb->base_prefix ) || '' === $wpdb->base_prefix ) {
	display_header();
	die(
		'<h1>' . __( 'Configuration Error' ) . '</h1>' .
		'<p>' . sprintf(
			/* translators: %s: wp-config.php */
			__( 'Your %s file has an empty database table prefix, which is not supported.' ),
			'<code>wp-config.php</code>'
		) . '</p></body></html>'
	);
}

// Set error message if DO_NOT_UPGRADE_GLOBAL_TABLES isn't set as it will break install.
if ( defined( 'DO_NOT_UPGRADE_GLOBAL_TABLES' ) ) {
	display_header();
	die(
		'<h1>' . __( 'Configuration Error' ) . '</h1>' .
		'<p>' . sprintf(
			/* translators: %s: DO_NOT_UPGRADE_GLOBAL_TABLES */
			__( 'The constant %s cannot be defined when installing WordPress.' ),
			'<code>DO_NOT_UPGRADE_GLOBAL_TABLES</code>'
		) . '</p></body></html>'
	);
}

/**
 * @global string    $wp_local_package
 * @global WP_Locale $wp_locale
 */
$language = '';
if ( ! empty( $_REQUEST['language'] ) ) {
	$language = preg_replace( '/[^a-zA-Z_]/', '', $_REQUEST['language'] );
} elseif ( isset( $GLOBALS['wp_local_package'] ) ) {
	$language = $GLOBALS['wp_local_package'];
}

$scripts_to_print = array( 'jquery' );

		if ( ! empty( $language ) && load_default_textdomain( $language ) ) {
			$loaded_language = $language;
			$GLOBALS['wp_locale'] = new WP_Locale();
		} else {
			$loaded_language = 'en_US';
		}

		if ( ! empty( $wpdb->error ) )
			wp_die( $wpdb->error->get_error_message() );

		$scripts_to_print[] = 'user-profile';
		$weblog_title 	= getenv('HOST');
		$user_name 		= getenv('DATAPORTEN_CREATOR');
		$public 		= 1;
		$identity 		= $user_name;

		$wpdb->show_errors();
		$result = wp_install( $weblog_title, $user_name, "foo@foo.foo", $public, '', wp_slash( wp_generate_password() ), WPLANG );
		add_user_meta($result["user_id"], 'dataporten_identity', 'dataporten|' . $identity . '|' . time());
			require_once( ABSPATH . "/wp-load.php" ); //not sure if this line is needed
                    //activate_plugin() is here:
                    require_once(  ABSPATH . "/wp-admin/includes/plugin.php");
                    $plugins = array_keys(get_plugins());
                    foreach ($plugins as $plugin){
                            //$plugin_path = $wordpress_path."wp-content/plugins/{$plugin}.php";
                            activate_plugin($plugin);
                    }
		// Log the user in and send them to wp-admin:
		if ( ! headers_sent() ) {              
            		wp_set_auth_cookie( $result['user_id'], true, is_ssl() );
            		wp_redirect( admin_url() );
            		exit;
        		}

        // If headers have already been sent, fall back to a "Success!" message:
        display_header();

?>

<h1><?php _e( 'Success!' ); ?></h1>

<p><?php _e( 'WordPress has been installed. Thank you, and enjoy!' ); ?></p>

<p class="step"><a href="<?php echo esc_url( wp_login_url() ); ?>" class="button button-large"><?php _e( 'Log In' ); ?></a></p>

<?php
		

if ( ! wp_is_mobile() ) {
	?>
<script type="text/javascript">var t = document.getElementById('weblog_title'); if (t){ t.focus(); }</script>
	<?php
}

wp_print_scripts( $scripts_to_print );
?>
<script type="text/javascript">
jQuery( function( $ ) {
	$( '.hide-if-no-js' ).removeClass( 'hide-if-no-js' );
} );
</script>
</body>
</html>
