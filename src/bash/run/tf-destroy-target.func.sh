#!/usr/bin/env bash
#
# The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
# https://developer.hashicorp.com/terraform/cli/commands/destroy
#
# $ ORG=org APP=app ENV=env STEP=000-step TARGET=packet_device.worker make do-tf-destroy

do_tf_destroy_target() {

  do_log "INFO START ::: provisioning step ${tf_proj}"

  TARGET=${TARGET:?}

  do_tf_init
  tf_destroy_log_fle=$PROJ_PATH/dat/log/tf_destroy.${ORG:-}-${APP:-}-${ENV:-}.${STEP:-}.log
  test -f $tf_destroy_log_fle && rm -f $tf_destroy_log_fle

  # do_backup_region_dynamo_db_tables "$AWS_PROFILE" "$AWS_REGION"

  vars_path="$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV/tf/$tf_proj.vars.tfvars"
  backend_config_path="$APP_PATH/$ORG-$APP-cnf/$ORG-$APP/$ENV/tf/$tf_proj.backend-config.tfvars"

  set -e

  echo "running: "
  #set -x

  terraform -chdir=${tf_run_path} init -backend-config=$backend_config_path -upgrade

  while IFS=',' read -ra TARGETS; do
    for target in "${TARGETS[@]}"; do
      terraform -chdir=${tf_run_path} apply -destroy -var-file=$vars_path -auto-approve -lock=false -target=${target} |
        tee -a $tf_destroy_log_fle
    done
  done <<<"$TARGET"

  rm -rf ${tf_run_path} #&& rm -rf ${modules_tgt_dir}
  set +x

  set +e

  do_simple_log "INFO STOP  ::: provisioning step ${tf_proj}"
  do_log "INFO ::: terraform destroy log file: $tf_destroy_log_fle"
  export EXIT_CODE=0

}
