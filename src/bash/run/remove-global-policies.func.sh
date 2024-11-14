#!/bin/env bash
# usage:
# AWS_PROFILE=rtr_adm STR_FILTER=kdm-wpb-dev ./run -a do_remove_global_policies
do_remove_global_policies() {

  export AWS_PROFILE=$(do_get_env_var "AWS_PROFILE")
  export STR_FILTER=$(do_get_env_var "STR_FILTER")

  # set -x
  # List all organization policies and extract policy IDs and names
  POLICIES=$(aws organizations list-policies --filter SERVICE_CONTROL_POLICY --query 'Policies[].[Id, Name]' --output text)

  while read -r POLICY_ID POLICY_NAME; do
    # Check if the policy name contains the search string
    if [[ $POLICY_NAME == *"$STR_FILTER"* ]]; then

      # List targets (OUs, accounts, or roots) attached to the policy
      TARGETS=$(aws organizations list-targets-for-policy \
        --policy-id "$POLICY_ID" --query 'Targets[].TargetId' --output text)

      # Detach the policy from each target
      for TARGET_ID in $TARGETS; do
        do_log "INFO Detaching policy $POLICY_NAME (ID: $POLICY_ID) from target ID: $TARGET_ID"
        aws organizations detach-policy --policy-id "$POLICY_ID" --target-id "$TARGET_ID"
        test $? -ne "0" && do_log "FATAL failed to detach policy $POLICY_ID" && exit 1
      done

      do_log INFO "Deleting policy: $POLICY_NAME (ID: $POLICY_ID)"
      aws organizations delete-policy --policy-id "$POLICY_ID"
      test $? -ne "0" && do_log "FATAL failed to delete policy $POLICY_ID" && exit 1

    fi
  done <<<"$POLICIES"

  export EXIT_CODE="0"

}
