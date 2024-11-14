#!/bin/bash

do_apply_ad_secrets_to_k8s() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}
  # do_set_env_vars_for_aws_account_master $ENV
  ad_secret_name='AD_SHARED_ACCOUNT'

  cmd="aws secretsmanager get-secret-value --region $AWS_REGION --profile $AWS_PROFILE"
  cmd="$cmd --secret-id $ad_secret_name"
  #eval "$cmd" | jq -r '.SecretString'

  AD_SHARED_ACCOUNT_ID=$(eval "$cmd" | jq -r '.SecretString' | jq -r '.Id' || echo "dummy-not-used-id")
  AD_SHARED_ACCOUNT_VAL=$(eval "$cmd" | jq -r '.SecretString' | jq -r '.Value' || echo "dummy-not-used-val")
  echo AD_SHARED_ACCOUNT_ID: $AD_SHARED_ACCOUNT_ID
  echo AD_SHARED_ACCOUNT_VAL: $AD_SHARED_ACCOUNT_VAL

  export KUBECONFIG=~/.kube/config.${ORG}-${APP}-${ENV}.adm

  k8s_secret_name='ad-shared-account'
  secret_exists=$(aws secretsmanager list-secrets --region $AWS_REGION --profile $AWS_PROFILE |
    jq '.SecretList[].Name' | grep $ad_secret_name | wc -l | xargs)
  kubectl delete secret -n 'apiv2' $k8s_secret_name --ignore-not-found
  echo running: kubectl -n apiv2 create secret generic $k8s_secret_name \
    "--from-literal=Id=$AD_SHARED_ACCOUNT_ID" \
    "--from-literal=Value=$AD_SHARED_ACCOUNT_VAL"
  kubectl -n apiv2 create secret generic $k8s_secret_name \
    "--from-literal=Id=$AD_SHARED_ACCOUNT_ID" \
    "--from-literal=Value=$AD_SHARED_ACCOUNT_VAL"
  rv=$?
  export EXIT_CODE=$?

  # to manually check whether those vales exist run ad-hoc with ENV on, these:
  # kubectl get -n apiv2 secrets/ad-shared-account -o jsonpath='{.data}'|jq -r '.AD_SHARED_ACCOUNT_ID'
  # kubectl get -n apiv2 secrets/ad-shared-account -o jsonpath='{.data}'|jq -r '.AD_SHARED_ACCOUNT_VAL'
  do_log 'INFO STOP  do_apply_ad_secrets_to_k8s'

}
