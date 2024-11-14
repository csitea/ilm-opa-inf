do_install_php() {

  # Setting the requirements
  do_require_var DOMAIN ${DOMAIN:-}

  # install general utils first
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y wget gnupg2 lsb-release ca-certificates \
    apt-transport-https software-properties-common zip unzip

  # Get repository for the php installation
  sudo add-apt-repository -y ppa:ondrej/php

  # Set up the php info page
  sudo cp -v $PROJ_PATH/dat/var/www/html/info.php \
    /var/www/html/$DOMAIN/

  #install the php binaries
  sudo apt update -y
  sudo apt install -y zip unzip curl wget vim perl ghostscript \
    php8.1 \
    php8.1-cli \
    php8.1-common \
    php8.1-fpm \
    php8.1-xmlrpc \
    php8.1-gd \
    php8.1-dev \
    php8.1-imap \
    php8.1-opcache \
    php8.1-soap \
    php8.1-redis php8.1-dom \
    php8.1-simplexml \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-imagick \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-xml \
    php8.1-zip \
    php8.1-readline \
    php-json \
    php-pear

  # Check the version
  php -v

  # Print a notice
  echo Check: http://$DOMAIN/info.php

  export EXIT_CODE="$?"
}
