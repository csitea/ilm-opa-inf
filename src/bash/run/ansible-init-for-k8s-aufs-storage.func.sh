#!/bin/bash

do_ansible_init_for_k8s_aufs_storage() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}

  export AWS_PROFILE="${ORG:-}_${APP:-}_${ENV:-}_rcr"

  #creating a tmp file
  temp_file=$(mktemp)

  # add "my_hosts" to tmp file
  echo "[my_hosts]" >"$temp_file"

  #Use the AWS CLI and jq to get the IP addresses and append them to the tmp file
  aws ec2 describe-instances --query 'Reservations[*].Instances[*]' | jq -r '.[] | .[] | select( if (.Tags | length) > 0 then (all(.Tags[]; .Key != "Name")) else true end ) | .PrivateIpAddress' | sort | uniq >>"$temp_file"

  #replace the ini file with the tmp file
  mkdir -p $PROJ_PATH/cnf/k8s/v1.25/$ORG/$APP/$ENV/
  mv $temp_file $PROJ_PATH/cnf/k8s/v1.25/$ORG/$APP/$ENV/inventory.ini

  export EXIT_CODE="0"
}
