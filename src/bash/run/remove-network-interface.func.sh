#!/bin/bash

# ORG=spe APP=prp ENV=dev NETWORK_INTERFACE_ID=eni-0f77b33733ab6b3f1 ./run -a do_remove_network_interface
do_remove_network_interface() {

  do_require_var NETWORK_INTERFACE_ID "${NETWORK_INTERFACE_ID:-}"
  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  export AWS_PROFILE="$ORG"'_'"$APP"'_'"$ENV"'_rcr'
  export AWS_REGION='us-east-1'

  echo AWS_PROFILE: $AWS_PROFILE
  echo AWS_REGION: $AWS_REGION

  # Replace with your network interface ID

  # Detach the network interface
  aws ec2 describe-network-interfaces --network-interface-ids $NETWORK_INTERFACE_ID |
    jq -r '.NetworkInterfaces[].Attachment.AttachmentId' | while read ATTACHMENT_ID; do

    if [ ! -z "$ATTACHMENT_ID" ]; then
      echo "Detaching network interface with attachment ID: $ATTACHMENT_ID"
      aws ec2 detach-network-interface --attachment-id $ATTACHMENT_ID --force
      echo "Waiting for network interface to be detached..."
      aws ec2 wait network-interface-available --network-interface-ids $NETWORK_INTERFACE_ID
    fi
  done

  # Delete the network interface
  echo "Deleting network interface with ID: $NETWORK_INTERFACE_ID"
  aws ec2 delete-network-interface --network-interface-id $NETWORK_INTERFACE_ID
  export EXIT_CODE=$?
  test $EXIT_CODE -ne "0" && do_log "FATAL failed to delete network-interface-id $NETWORK_INTERFACE_ID" && exit 1
  do_log "INFO Network interface deleted successfully."

}
