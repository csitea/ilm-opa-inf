#!/usr/bin/env bash

do_tf_apply_target() {

  do_log "INFO START ::: provisioning step ${STEP}"

  TARGET=${TARGET:?}

  do_tf_init

  # do_backup_region_dynamo_db_tables "$AWS_PROFILE" "$AWS_REGION"

  vars_path="$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV/tf/$tf_proj.vars.tfvars"
  backend_config_path="$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV/tf/$tf_proj.backend-config.tfvars"

  set -e

  echo "running: "
  #set -x

  terraform -chdir=${tf_run_path} init -backend-config=$backend_config_path -upgrade

  while IFS=',' read -ra TARGETS; do
    for target in "${TARGETS[@]}"; do
      terraform -chdir=${tf_run_path} apply -var-file=$vars_path -auto-approve -lock=false -target=${target}
    done
  done <<<"$TARGET"

  rm -rf ${tf_run_path} #&& rm -rf ${modules_tgt_dir}
  set +x

  set +e

  do_simple_log "INFO STOP  ::: provisioning step ${tf_proj}"
  do_log "INFO ::: terraform apply log file: $tf_apply_log_fle"
  export EXIT_CODE=0

}
