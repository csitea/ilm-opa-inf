#!/bin/bash

do_configure_ufw_firewall() {

  # Check the updates
  sudo apt update -y

  # Configuring the ufw firewall
  sudo ufw allow 22/tcp comment 'Open port ssh tcp port 22'
  sudo ufw allow 80/tcp comment 'Open port http tcp port 80'
  sudo ufw allow 443/tcp comment 'Open port https tcp port 443'
  sudo ufw app list
  sudo ufw status
  sudo ufw --force enable
  sudo ufw status

  export EXIT_CODE=$?

}
