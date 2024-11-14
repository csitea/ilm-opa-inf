#!/bin/bash
do_list_all_acm_certificates() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}

  AWS_REGION=${AWS_REGION:-us-east-1}

  AWS_PROFILE="${ORG:-}_${APP:-}_${ENV:-}_rcr"

  ACM_CERTIFICATES=$(aws --region=$AWS_REGION --profile=$AWS_PROFILE acm list-certificates | jq -r '.CertificateSummaryList[] | {CertificateArn, DomainName, InUse}')

  #output:
  echo "$ACM_CERTIFICATES"

  export EXIT_CODE=0
}
