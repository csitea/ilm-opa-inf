#!/bin/bash
# when a master adds a new infra admin to an org-env-app
do_aws_add_new_infra_admin_user() {

  do_require_var ORG "${ORG:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var APP "${APP:-}"
  do_require_var USER_NAME "${USER_NAME:-}"

  test -z ${AWS_PROFILE:-} && export AWS_PROFILE=$ORG-$APP-$ENV-idy-master
  # Generate the a nice new user password
  user_pw=$(openssl rand -base64 16 | tr '+/' '-_' | tr -d '=')'!'

  cmd="aws iam create-user --profile $AWS_PROFILE --user-name $USER_NAME"
  echo -e "running: \n $cmd"
  $cmd
  rv=$?
  test $rv != "0" && do_log "FATAL failed to create-login-profile" && return

  cmd="aws iam create-login-profile --profile $AWS_PROFILE \
    --user-name $USER_NAME --password $user_pw --password-reset-required"
  echo -e "running: \n $cmd"
  $cmd
  rv=$?
  test $rv != "0" && do_log "FATAL failed to create-login-profile" && return

  group_Admins_exists=$(aws iam list-groups | jq -r '.Groups[]|.GroupName' | grep 'Admins' | wc -l | xargs)
  if [[ ${group_Admins_exists:-} -ne 1 ]]; then
    aws iam create-group --group-name Admins
    aws iam attach-group-policy --group-name Admins \
      --policy-arn 'arn:aws:iam::aws:policy/AdministratorAccess'
    aws iam list-attached-group-policies --group-name Admins
  fi

  cmd="aws iam  add-user-to-group --profile $AWS_PROFILE \
    --user-name $USER_NAME --group-name Admins"
  echo -e "running: \n $cmd"
  $cmd
  rv=$?
  test $rv != "0" && do_log "FATAL failed to add-user-to-group" && return

  aws_acc_id=$(aws iam list-users --profile $AWS_PROFILE |
    jq -r '.Users[]|select(.Arn|contains ("'$USER_NAME'"))|.Arn' | awk -F\: '{print $5}')
  echo "provide to the user the following login url:"
  echo "https://${aws_acc_id}.signin.aws.amazon.com/console/"
  echo "provide the following pw to the user via SMS: $user_pw"

  export EXIT_CODE=0
}
