do_sync_wg_peers(){

  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  do_wireguard_generate_peers
  do_get_wg_key
  do_generate_wg_conf_header

  do_require_var PEERS_BLOCK "${PEERS_BLOCK:-}"
  do_require_var WG_CONF "${WG_CONF:-}"

  TARGET_HOST="wireguard.${ORG}.${APP}.${ENV}.aws.spectralengines.com"
  SSH_KEY_PATH="${HOME}/.ssh/.${ORG}/${ORG}-${APP}-${ENV}-050-wireguard-key-pair.pk"

    # Create a temporary file
  TEMP_FILE=$(mktemp)
  echo -e "${WG_CONF}\n\n${PEERS_BLOCK}" > "$TEMP_FILE"

  ansible-playbook -i $TARGET_HOST, /$BASE_PATH/${ORG}/infra-core/src/ansible/sync-wg-peers.yaml --extra-vars "temp_file_path=$TEMP_FILE" --private-key $SSH_KEY_PATH

  # Remove the temporary file when done
  # cat $TEMP_FILE > tmp
  rm "$TEMP_FILE"
}
