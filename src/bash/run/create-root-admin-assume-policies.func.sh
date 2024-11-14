#!/bin/bash
# when a master adds a new infra admin to an org-env-app
do_create_root_admin_assume_policies() {

  while read -r acc_id; do
    policy_document="$(
      cat <<EOF
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "AWS": "arn:aws:iam::"$acc_id":root"
         },
         "Action": "sts:AssumeRole"
       }
     ]
   }
EOF
    )"

    aws iam create-policy --policy-name "iam_policy_assume_iam_role_root_admin" \
      --policy-document "$policy_document"

  done < <(aws organizations list-accounts | jq -r '.Accounts[]|(.Id)')
  export EXIT_CODE=0
}
