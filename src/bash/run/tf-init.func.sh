#!/usr/bin/env bash
# init terraform for the current step , copy the modules and the step folder
# to the run path and export the required vars
do_tf_init() {

  tf_proj=${STEP:?}
  tgt_app=${APP:?}

  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var STEP "${STEP:-}"
  do_require_var ACTION "${ACTION:-provision}" # fail safe, never destroy if something breaks

  ENV_CONF_JSON_FLE="$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV.env.json"

  do_export_json_section_vars_as_tf_vars "$ENV_CONF_JSON_FLE" ".env.aws"
  do_export_json_section_vars_as_tf_vars "$ENV_CONF_JSON_FLE" ".env.gcp"

  do_export_json_section_vars "$ENV_CONF_JSON_FLE" ".env.terrafom"
  do_export_json_section_vars "$ENV_CONF_JSON_FLE" ".env.gcp"
  do_export_json_section_vars "$ENV_CONF_JSON_FLE" ".env.aws"
  do_export_json_section_vars "$ENV_CONF_JSON_FLE" ".env.github"
  do_export_json_section_vars "$ENV_CONF_JSON_FLE" ".env.versions"
  do_export_json_section_vars "$ENV_CONF_JSON_FLE" '.env.steps."'${STEP}'"'

  export TF_VAR_proj_path="${PROJ_PATH}"
  export TF_VAR_base_path="${BASE_PATH}"
  export TF_VAR_org_path="${ORG_PATH}"
  export tf_run_path=${PROJ_PATH}/bin/${ORG}/${APP}/${ENV}/${tf_proj}
  export TF_LOG=ERROR # DEBUG, TRACE, INFO, WARN or ERROR
  export TF_VAR_TERRAFORM_VERSION=${TERRAFORM_VERSION}
  export TF_VAR_INFRA_VERSION=${INFRA_VERSION}
  export TF_VAR_CNF_VER="$(git rev-parse --short HEAD)"
  export TF_VAR_STEP=${STEP:-}
  export TF_GITHUB_TOKEN=${GITHUB_TOKEN:-}
  export GOOGLE_APPLICATION_CREDENTIALS=$(eval echo "~/.gcp/.$ORG/key-$ORG-$APP-$ENV.json")
  export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache/$ORG/$APP/$ENV/$STEP"

  # env | sort
  # sleep 10

  test -d "$TF_PLUGIN_CACHE_DIR" || mkdir -p "$TF_PLUGIN_CACHE_DIR"

  tfswitch ${TERRAFORM_VERSION}
  quit_on "switching  to terraform version ${TERRAFORM_VERSION}"

  tf_src_path="$PROJ_PATH/src/terraform/$tf_proj"
  # Only remove the tf_run_path if the ACTION is destroy
  # if [[ "${ACTION}" == "destroy" ]]; then
  test -d ${tf_run_path} && rm -r ${tf_run_path}
  # fi

  mkdir -p ${PROJ_PATH}/bin/${ORG}/${APP}/${ENV}
  cp -r ${tf_src_path} ${tf_run_path}

  md5modules_bin=$(find ${tf_run_path}/../modules -type f -exec md5sum {} \; | md5sum)
  md5modules=$(find ${tf_src_path}/../modules -type f -exec md5sum {} \; | md5sum)

  # if they're not equal, the copy again
  if [[ "${md5modules_bin}" == "${md5modules}" ]]; then
    do_log "INFO modules folder MD5 is consistent: ${md5modules}"
    do_log "INFO sync is not needed"
  else
    do_log "WARNING modules folder MD5 diverged: ${md5modules_bin} -- ${md5modules}"
    do_log "INFO copying ${tf_src_path} to ${tf_run_path}"
    rm -rf "${tf_run_path}/../modules" && cp -r "${tf_src_path}/../modules" "${tf_run_path}/../"
  fi

  do_log "INFO copying ${tf_src_path} to ${tf_run_path}"

}
