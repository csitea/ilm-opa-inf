do_wireguard_generate_peers(){
  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  YAML_PEER_FILE="$BASE_PATH/$ORG/$ORG-$APP-infra-conf/$APP/${ENV}/050-wireguard/peers.yaml"
  YAML_CONF_FILE="$BASE_PATH/$ORG/$ORG-$APP-infra-conf/$APP/$ENV.env.yaml"

  IP_PREFIX=$(yq -r '.env.steps."050-wireguard".ip_prefix' $YAML_CONF_FILE)

  length=$(yq -r '.peers | length' $YAML_PEER_FILE)

  # Declare an empty variable to hold the concatenated block
  CONCATENATED_BLOCK=""

  # Iterate over each peer and create the configuration block
  for ((i=0; i<$length; i++)); do
    CLIENT_IP=$(yq -r ".peers[$i].ip" $YAML_PEER_FILE)
    CLIENT_PUBLIC_KEY=$(yq -r ".peers[$i].public_key" $YAML_PEER_FILE)
    DESCRIPTION=$(yq -r ".peers[$i].description" $YAML_PEER_FILE)

    read -r -d '' BLOCK << EOB
[Peer]
# ${DESCRIPTION}
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = ${IP_PREFIX}.${CLIENT_IP}
PersistentKeepalive = 25
EOB

    # Concatenate the current block with the previous ones
    CONCATENATED_BLOCK+="$BLOCK\n\n"
  done

  export PEERS_BLOCK=$CONCATENATED_BLOCK
}
