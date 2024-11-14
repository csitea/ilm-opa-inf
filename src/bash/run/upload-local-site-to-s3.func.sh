#!/bin/bash

do_upload_local_site_to_s3() {
  aws s3 sync --delete src/nodejs/infra-monitor-ui/dist/infra-monitor-ui/ s3://${ORG}-${APP}-${ENV}.013-wpbs-infra-mon.infra-monitor --acl public-read

  export EXIT_CODE=$?
}
