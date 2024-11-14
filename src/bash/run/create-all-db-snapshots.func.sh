#!/bin/bash

do_create_all_db_snapshots() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}
  AWS_REGION=${AWS_REGION:-us-east-1}

  AWS_PROFILE="${ORG:-}_${APP:-}_${ENV:-}_rcr"
  dt=$(date "+%Y%m%d-%H%M%S")
  # do_set_env_vars_for_aws_account_master ${ENV:-}

  aws rds describe-db-instances --profile $AWS_PROFILE --region $AWS_REGION | jq -r '.DBInstances[].DBInstanceIdentifier' |
    while read -r db_instance; do
      do_log "INFO START attempt to backup the following db instance: $db_instance"
      export db_instance=$db_instance
      #set -x
      aws rds create-db-snapshot --profile $AWS_PROFILE --region $AWS_REGION \
        --db-instance-identifier $db_instance \
        --db-snapshot-identifier $db_instance'-'$dt | jq '.'
      #set -x
      sleep 2
    done

  export EXIT_CODE="0"
}
