do_get_wg_key() {
  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}
  PROFILE="${ORG}_${APP}_${ENV}_rcr"
  SECRET_ID="${ORG}-${APP}-${ENV}/wireguard-ssh-key"
  KEY_PATH="$HOME/.ssh/.${ORG}/${ORG}-${APP}-${ENV}-050-wireguard-key-pair.pk"

  do_log "INFO Retrieving secret from AWS Secrets Manager..."
  aws secretsmanager --profile "${PROFILE}" get-secret-value --secret-id "${SECRET_ID}" | jq -r '.SecretString' >"${KEY_PATH}"
  chmod 600 "${KEY_PATH}"

  if [ $? -eq 0 ]; then
    do_log "SUCCESS Secret successfully retrieved and saved to ${KEY_PATH}"
  else
    do_log "ERROR An error occurred while retrieving and saving the secret."
    exit 1
  fi

  do_log "HINT To connect to the wireguard instance use"
  echo "ssh -i $HOME/.ssh/.${ORG}/${ORG}-${APP}-${ENV}-050-wireguard-key-pair.pk ubuntu@wireguard.${ORG}.${APP}.${ENV}.aws.spectralengines.com"
  export EXIT_CODE="0"
}
