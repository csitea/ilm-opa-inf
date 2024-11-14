#!/bin/bash

ORG=$1
APP=$2
ENV=$3
BASE_PATH=$4
kbdx_db_key_file_name=$5

APP_U=$(echo $APP | tr '[:lower:]' '[:upper:]')
ORG_U=$(echo $ORG | tr '[:lower:]' '[:upper:]')
ENV_U=$(echo $ENV | tr '[:lower:]' '[:upper:]')

password=$(keepassxc-cli show --no-password --quiet \
  $BASE_PATH/$ORG/$ORG-$APP/$ORG-$APP-crs/$ORG-$APP.kdbx \
  $ORG_U-$APP_U/$ENV_U-ENV/GOOGLE/smtp-password-$ORG-$APP-$ENV \
  --key-file='/home/appusr/.ssh/.'$ORG'/'"$kbdx_db_key_file_name" \
  --attributes=Password)

# Return the result as a JSON object
echo "{\"password\":\"$password\"}"
