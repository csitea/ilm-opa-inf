#!/usr/bin/env bash

do_provision() {

  do_tf_init

  # the state bucket name OR it's naming convention should be fetched from the conf
  # and not built dynamically in the different runtmes ...
  bucket=${STATE_BUCKET:-}
  export TF_VAR_STEP=${STEP:?}

  do_log "INFO running checking the bucket"
  do_log "INFO bucket_name: ${bucket}"

  if [[ "${ACTION}" == "divest" ]]; then
    # divest
    do_tf_destroy "${STEP}"

    # As agreed in 2207291920 :::
    # Remote buckets will be provisioned and remain in the account until further notice.
    # This allows us to keep a single version of tfstate through the code, and enjoy
    # all the functionalities s3 state storing provides, without breaking states or
    # being locked by AWS console/cli caching.
    do_log "INFO 2207291920 ::: remote buckets need to be manually removed"
    echo do_tf_destroy_local_step_bucket "${STEP}-remote-bucket"
  else
    do_tf_apply "${STEP}"
  fi

  rv=$?
  test $rv == "0" && export EXIT_CODE=0
}
