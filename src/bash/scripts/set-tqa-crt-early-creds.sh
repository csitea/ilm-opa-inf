#!/bin/env bash

# Early credentials and step specifics ::: add logic here only once
eval export TF_VAR_GITHUB_TOKEN="\${${ORG^^}_${APP^^}_${ENV^^}_GITHUB_TOKEN}"                    # 005-sys-users
eval export TF_VAR_HCLOUD_TOKEN="\${${ORG^^}_${APP^^}_${ENV^^}_HCLOUD_TOKEN}"                    # 005-sys-users
# todo: point to a TGT_APP=
# lgm
# csi-lgm-dev, csi-lgm-tst, csi-lgm-prd
eval export GOOGLE_APPLICATION_CREDENTIALS="~/.gcp/.tqa/key-tqa-all-all.json"

