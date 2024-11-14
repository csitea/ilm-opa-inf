#!/bin/bash

do_ubuntu_check_install_aws_cli() {
  # Install AWS-Cli
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&
    unzip awscliv2.zip &&
    sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin &&
    aws --version &&
    rm -f awscliv2.zip

  export EXIT_CODE=$?
}
