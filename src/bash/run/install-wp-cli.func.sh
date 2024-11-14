#!/bin/bash

do_install_wp_cli() {

  # Upload wp-cli to tpm-folder
  sudo mkdir -p /tmp/$PROJ/dat/
  cd /tmp/$PROJ/dat/
  sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  php wp-cli.phar --info

  # Move wp-cli into a bin folder
  sudo chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
  wp --info

  export EXIT_CODE=$?

}
