#!/usr/bin/env bash
# This function requires all variables necessary for basic
# terraform and steps. Any time you need extra variables,
# add the logic outside this file and leave here only the
# core variables.
do_tf_header() {
  tf_proj=${STEP:?}
  tgt_app=${APP:?}

  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var STEP "${STEP:-}"
  do_require_var ACTION "${ACTION:-provision}" # fail safe, never destroy if something breaks

  export GIT_SSH_COMMAND="ssh -p 22 -i ~/.ssh/.$ORG/id_rsa.$ORG"

  eval export TF_VAR_proj_path="${PROJ_PATH}"
  eval export TF_VAR_base_path="${BASE_PATH}"
  eval export TF_VAR_org_path="${ORG_PATH}"


  do_export_json_section_vars_as_tf_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.aws"
  do_export_json_section_vars_as_tf_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.gcp"

  # env | sort
  # sleep 10
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.terrafom"
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.gcp"
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.aws"
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.github"
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" ".env.versions"
  do_export_json_section_vars "$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json" '.env.steps."'${STEP}'"'

  # used for tagging cloud resources
  export TF_VAR_TERRAFORM_VERSION=${TERRAFORM_VERSION}
  export TF_VAR_INFRA_VERSION=${INFRA_VERSION}

  do_log INFO TERRAFORM_VERSION: $TERRAFORM_VERSION
  do_log INFO INFRA_VERSION: $INFRA_VERSION

  export TF_VAR_CNF_VER="$(git rev-parse --short HEAD)"
  export TF_VAR_STEP=${STEP:-}
  export GOOGLE_APPLICATION_CREDENTIALS=$(eval echo "~/.gcp/.$ORG/key-$ORG-$APP-$ENV.json")

  export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache/$ORG/$APP/$ENV/$STEP"
  test -d "$TF_PLUGIN_CACHE_DIR" || mkdir -p "$TF_PLUGIN_CACHE_DIR"

  tfswitch ${TERRAFORM_VERSION}

  tf_path="$PROJ_PATH/src/terraform/$tf_proj"
  export bin_dir=${PROJ_PATH}/bin/${ORG}/${APP}/${ENV}/${tf_proj}

  test -d ${bin_dir} && rm -r ${bin_dir}


  mkdir -p ${PROJ_PATH}/bin/${ORG}/${APP}/${ENV}
  cp -rv ${tf_path} ${bin_dir}


  md5modules_bin=$(find ${bin_dir}/../modules -type f -exec md5sum {} \; | md5sum)
  md5modules=$(find ${tf_path}/../modules -type f -exec md5sum {} \; | md5sum)

  # if they're not equal, the copy again
  if [[ "${md5modules_bin}" == "${md5modules}" ]]; then
    do_log "INFO modules folder MD5 is consistent: ${md5modules}"
    do_log "INFO sync is not needed"
  else
    do_log "WARNING modules folder MD5 diverged: ${md5modules_bin} -- ${md5modules}"
    do_log "INFO copying ${tf_path} to ${bin_dir}"
    rm -rf "${bin_dir}/../modules" && cp -r "${tf_path}/../modules" "${bin_dir}/../"
  fi

  do_log "INFO copying ${tf_path} to ${bin_dir}"

}
