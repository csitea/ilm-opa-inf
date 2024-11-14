do_install_mysql() {

  # Setting the requirements
  do_require_var DATABASE ${DATABASE:-}
  do_require_var USER ${USER:-}
  do_require_var PASSWORD ${PASSWORD:-}
  do_require_var HOST ${HOST:-}

  # Install the mysql server
  # sudo apt-get update
  sudo apt-get install -y mysql-server
  sudo apt-get install -y php-mysql
  # extension=php_mysqli.so

  # Set up the mysql
  IFS='' read -r -d '' mysql_code <<EOF_MYSQL_CODE

   CREATE DATABASE $DATABASE ;

   CREATE USER $USER@$HOST IDENTIFIED BY '$PASSWORD' ;

   GRANT ALL PRIVILEGES ON *.* TO $USER@$HOST ;

   FLUSH PRIVILEGES ;


EOF_MYSQL_CODE

  echo "$mysql_code" | sudo mysql

  export EXIT_CODE="$?"

}
