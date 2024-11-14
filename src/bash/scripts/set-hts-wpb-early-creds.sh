#!/bin/env bash

do_export_json_section_vars "$PROJ_PATH/cnf/env/$ORG/$APP/$ENV.env.json" ".env.gcp"

# Early credentials and step specifics ::: add logic here only once
eval export TF_VAR_GITHUB_TOKEN="\${${ORG^^}_${APP^^}_${ENV^^}_GITHUB_TOKEN}"                    # 005-sys-users
# OBS: switch from default platform conf to tgt project org and app conf !!!
eval export GOOGLE_APPLICATION_CREDENTIALS="~/.gcp/.$ORG/key-$ORG-$APP-$ENV.json"
#eval export TF_VAR_AWS_SHARED_CREDENTIALS_FILE="~/.aws/.$ORG/credentials" # Set Terraform AWS credentials file path

