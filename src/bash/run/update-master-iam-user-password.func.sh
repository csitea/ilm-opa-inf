#!/bin/bash

do_update_master_iam_user_password() {

  do_require_var USER_NAME ${USER_NAME:-}
  do_require_var PASSWORD ${PASSWORD:-}
  #export USER_NAME='first.last@valuemotive.com';
  #export PASSWORD='Really%56Secret?'

  # yes, must use the rtr adm sess !!!
  aws --region 'us-east-1' --profile 'rtr_adm_sess' iam update-login-profile \
    --user-name "$USER_NAME" --password "$PASSWORD" --password-reset-required

}
