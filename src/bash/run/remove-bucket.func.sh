#!/bin/bash

do_remove_bucket() {

  do_require_var BUCKET "${BUCKET:-}"
  do_require_var AWS_PROFILE "${AWS_PROFILE:-}"

  do_log INFO check bucket: $BUCKET before the delete
  aws s3 ls --profile $AWS_PROFILE $BUCKET

  aws s3api delete-objects --profile $AWS_PROFILE --bucket ${BUCKET} \
    --delete "$(aws s3api --profile $AWS_PROFILE list-object-versions \
      --bucket "${BUCKET}" \
      --output=json \
      --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

  aws s3api --profile $AWS_PROFILE delete-bucket --bucket $BUCKET

  do_log INFO check bucket: $BUCKET after the delete
  aws s3 ls --profile $AWS_PROFILE $BUCKET

  export EXIT_CODE="0"

}
