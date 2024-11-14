#!/bin/bash

do_fix_iam_roles_session_duration() {

  # Get all IAM roles
  roles=$(aws iam list-roles --query 'Roles[].RoleName' --output text | grep _iam_)

  roles=$(
    cat <<EOF
csi_wpb_stg_data_scientists
csi_wpb_stg_be_developers
csi_wpb_dev_be_developers
csi_wpb_tst_data_scientists
csi_wpb_dev_data_scientists
csi_wpb_tst_be_developers
EOF
  )

  # Loop through the roles and update MaxSessionDuration to 8 hours (28800 seconds)
  while read -r role; do
    echo "Updating role: $role"
    echo "running: "
    export AWS_PROFILE=${role:0:11}"_idy"
    #export AWS_PROFILE="csi_wpb_all_idy"
    export AWS_REGION='us-east-1'
    echo aws iam update-role --profile $AWS_PROFILE --region $AWS_REGION --role-name "$role" --max-session-duration 28800
  done < <(echo "$roles")

  echo "All roles updated successfully."

}
