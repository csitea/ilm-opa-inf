#!/usr/bin/env bash

do_aws_generate_roles_switching() {
  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.aws"

  set -e

  timestamp=$(date +"%Y%m%d%H%M")
  tmp_file=bin/${timestamp}.creds # infra/bin is not versioned
  rm -f bin/*.creds && touch ${tmp_file}

  echo "${timestamp}" >>${tmp_file}
  echo "===================================" >>${tmp_file}
  for TYPE in rcr log idy; do
    # for each type of account [rcr, log, idy]
    aws_roles=$(aws iam list-roles --profile ${ORG}_${APP}_${ENV}_${TYPE} | jq -c '.Roles[] | select(.RoleName | contains ("aws_iam_role") )')
    for role_name in $(echo ${aws_roles} | jq -c '.RoleName'); do
      profile_name=$(echo ${role_name} | sed "s/aws_iam_role/${ORG}_${APP}_${ENV}/g;s/\"//g; s/$/_${TYPE}/")

      echo >>${tmp_file}
      echo "[${profile_name}]" >>${tmp_file}
      echo "source_profile = rtr_adm" >>${tmp_file}
      echo "role_arn = $(echo ${aws_roles} | jq -c "select(.RoleName | contains ("${role_name}")) | .Arn")" >>${tmp_file}
      echo "output = json" >>${tmp_file}
      echo "region = ${AWS_REGION}" >>${tmp_file}
      echo >>${tmp_file}

    done
  done

  do_log "INFO to add the credentials into your AWS_SHARED_CREDENTIALS_FILE"
  cat ${tmp_file}
  echo "cat ${tmp_file} >> \$AWS_SHARED_CREDENTIALS_FILE"
  echo "cat ${tmp_file} >> ~/.aws/.${ORG}/credentials"

  #[`echo ${account_name} | sed s/-/_/g`]
  # switch from AWS root account to ${account_name} admin role
  #source_profile = rtr_adm
  #role_arn = arn:aws:iam::${account_id}:role/${ENV}_iam_role_root_admin
  #region = ${AWS_REGION}
  #output = json

  export EXIT_CODE=0
}
