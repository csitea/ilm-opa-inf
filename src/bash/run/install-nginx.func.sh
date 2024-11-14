#!/bin/bash

do_install_nginx() {

  # Setting the requirements
  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}
  do_require_var DOMAIN ${DOMAIN:-}

  # Installing the Nginx
  sudo add-apt-repository ppa:ondrej/nginx-mainline
  sudo apt install -y nginx

  # Get the index.html for the webserver
  sudo mkdir -p /var/www/html/$DOMAIN
  test -f /var/www/html/index.nginx-debian.html &&
    sudo mv -v /var/www/html/index.nginx-debian.html /var/www/html/$DOMAIN/index.html

  # Configure sites-enabled confs
  test -f /etc/nginx/sites-enabled/default && sudo rm -v /etc/nginx/sites-enabled/default
  sudo cp -v $APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV/etc/nginx/conf.d/$DOMAIN.conf \
    /etc/nginx/sites-available/$DOMAIN.conf

  # Configure nginx confs
  sudo ln -sfn /etc/nginx/sites-available/$DOMAIN.conf \
    /etc/nginx/sites-enabled/$DOMAIN.conf

  # Update the webserver folder permissions
  sudo chown -R www-data:www-data /var/www/html/

  # Restart and status of nginx
  sudo service nginx restart
  sudo service nginx status

  # todo?
  # curl http://$DOMAIN/

  export EXIT_CODE=$?
}
