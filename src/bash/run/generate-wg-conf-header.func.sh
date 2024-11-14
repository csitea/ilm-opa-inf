do_generate_wg_conf_header(){

  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  YAML_CONF_FILE="$BASE_PATH/$ORG/$ORG-$APP-infra-conf/$APP/$ENV.env.yaml"
  JSON_EARLY_CREDS="$HOME/.aws/.$ORG/$ORG-$APP.early-credentials.json"

  SERVER_PORT=$(yq -r '.env.steps."050-wireguard".wg_server_port' $YAML_CONF_FILE)
  IP_PREFIX=$(yq -r '.env.steps."050-wireguard".ip_prefix' $YAML_CONF_FILE)
  CIDR_RANGE=$(yq -r '.env.steps."050-wireguard".wg_server_net' $YAML_CONF_FILE)
  WG_PRIVATE_KEY=$(jq -r ".${ORG}_${APP}_${ENV}_wg_server_private_key" $JSON_EARLY_CREDS)

  read -r -d '' BLOCK << EOB
[Interface]
Address = ${IP_PREFIX}.${CIDR_RANGE}
PrivateKey = ${WG_PRIVATE_KEY}
ListenPort = ${SERVER_PORT}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; iptables -A INPUT -p tcp --dport 443 -j ACCEPT; iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT; iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOB

  export WG_CONF=$BLOCK

}
