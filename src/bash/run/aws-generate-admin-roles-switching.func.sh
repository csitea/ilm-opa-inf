#!/usr/bin/env bash

do_aws_generate_admin_roles_switching() {
  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.aws"

  set -e
  do_log "INFO fetching AWS non-root accounts for ORG=${ORG} APP=${APP} ENV=${ENV}"
  aws_accounts=$(AWS_SHARED_CREDENTIALS_FILE=${AWS_SHARED_CREDENTIALS_FILE} aws organizations list-accounts --profile ${AWS_PROFILE} | jq -c '.Accounts[]')
  for account in ${aws_accounts}; do
    account_name=$(echo ${account} | jq -c '.Name' | sed s/\"//g)
    account_id=$(echo ${account} | jq -c '.Id' | sed s/\"//g)
    if [[ ${account_name} = "${ORG}-${APP}-${ENV}-"* ]]; then
      echo "
[$(echo ${account_name} | sed s/-/_/g)]
# switch from AWS root account to ${account_name} admin role
source_profile = rtr_adm
role_arn = arn:aws:iam::${account_id}:role/${ENV}_iam_role_root_admin
region = ${AWS_REGION}
output = json
"
    fi
  done
  set +e

  export EXIT_CODE=0
}
