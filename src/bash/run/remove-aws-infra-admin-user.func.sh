#!/bin/bash
# when a master adds a new infra admin to an org-env-app
do_remove_aws_infra_admin_user() {

  do_require_var ORG "${ORG:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var APP "${APP:-}"
  do_require_var USER_NAME "${USER_NAME:-}"
  test -z ${AWS_PROFILE:-} && export AWS_PROFILE=$AWS_PROFILE

  while read -r g; do

    cmd="aws iam --profile $AWS_PROFILE remove-user-from-group \
        --user-name $USER_NAME --group-name $g"
    echo -e "running: \n $cmd"
    $cmd
    rv=$?
    test $rv != "0" && do_log "FATAL failed to create-login-profile" && return

  done < <(aws iam --profile "$AWS_PROFILE" list-groups | jq -r '.Groups[]|.GroupName')

  cmd="aws iam delete-login-profile --profile "$AWS_PROFILE" --user-name $USER_NAME"
  echo -e "running: \n $cmd"
  $cmd
  rv=$?
  test $rv != "0" && do_log "FATAL failed to delete-login-profile" && return

  cmd="aws iam delete-user --profile $AWS_PROFILE --user-name $USER_NAME"
  echo -e "running: \n $cmd"
  $cmd
  rv=$?
  test $rv != "0" && do_log "FATAL failed to delete-user" && return

  export EXIT_CODE=0

}
