#!/bin/bash

do_deploy_wordpress() {

  # Setting the requirements
  do_require_var DOMAIN ${DOMAIN:-}
  do_require_var SITE_TITLE ${SITE_TITLE:-}
  do_require_var SITE_USER ${SITE_USER:-}
  do_require_var SITE_PASS ${SITE_PASS:-}
  do_require_var SITE_EMAIL ${SITE_EMAIL:-}
  do_require_var SITE_LOCAL ${SITE_LOCAL:-}
  do_require_var DATABASE ${DATABASE:-}
  do_require_var USER ${USER:-}
  do_require_var PASSWORD ${PASSWORD:-}
  do_require_var HOST ${HOST:-}
  do_require_var PREFIX ${PREFIX:-}

  # Upload wordpress to tpm-folder
  sudo mkdir -p /tmp/$PROJ/dat/
  sudo wget 'https://wordpress.org/latest.zip' -O /tmp/$PROJ/dat/latest.zip

  # Unzip the wordpress to webserver
  sudo unzip latest.zip -d /usr/share/nginx/
  sudo unzip -o /tmp/$PROJ/dat/latest.zip -d /var/www/html/$DOMAIN/
  cd /var/www/html/$DOMAIN/wordpress/
  sudo mv * ../

  # Do clean up
  cd /var/www/html/$DOMAIN
  sudo rm -r /tmp/$PROJ/dat/*
  sudo rm -r wordpress
  sudo rm -r info.php
  sudo rm -r index.html

  # Copy the wp-config
  sudo cp -v /var/www/html/$DOMAIN/wp-config-sample.php \
    /var/www/html/$DOMAIN/wp-config.php

  # Update the wp-configs
  sudo perl -pi -e "s|database_name_here|$DATABASE|g" /var/www/html/$DOMAIN/wp-config.php
  sudo perl -pi -e "s|username_here|$USER|g" /var/www/html/$DOMAIN/wp-config.php
  sudo perl -pi -e "s|password_here|$PASSWORD|g" /var/www/html/$DOMAIN/wp-config.php
  sudo perl -pi -e "s|localhost|$HOST|g" /var/www/html/$DOMAIN/wp-config.php
  sudo perl -pi -e "s|wp_|$PREFIX|g" /var/www/html/$DOMAIN/wp-config.php

  # Do the rest of the installation steps
  cd /var/www/html/$DOMAIN
  wp core install --url=$DOMAIN --title=$SITE_TITLE --admin_user=$SITE_USER --admin_password=$SITE_PASS --admin_email=$SITE_EMAIL --locale=$SITE_LOCAL --skip-email

  # Set permissions
  sudo chown -R www-data:www-data /var/www/html/$DOMAIN/
  sudo chown -R ubuntu /var/www/html/$DOMAIN/wp-content/

  # Restart the nginx
  sudo service nginx restart
  sudo service nginx status

  export EXIT_CODE=$?

}
