#!/bin/bash
#
# USER_NAME=sebastian.strippel@spectralengines.com ./run -a do_report_aws_iam_user_access \
#   | tee -a 2>&1 ~/Desktop/report-access-for-$USER_NAME.log
# less -r ~/Desktop/report-access-for-$USER_NAME.log

do_aws_report_iam_user_access() {

  # do_require_var USER_NAME ${USER_NAME:-}
  #export USER_NAME='sebastian.strippel@spectralengines.com'

  echo START ::: list the groups to which the user: ${USER_NAME:-} belongs to:
  echo running:
  echo running aws iam --profile csi_wpb_all_rcr list-groups-for-user --user-name "$USER_NAME"
  aws iam --profile $ORG'_'$APP'_all_idy' list-groups-for-user --user-name "$USER_NAME" |
    jq -r '.Groups[]|.GroupName'

  while read -r group; do
    echo START ::: list the group policies for the $group group
    echo running:
    echo aws iam --profile $ORG'_'$APP'_all_idy' list-group-policies --group-name $group
    aws iam --profile $ORG'_'$APP'_all_idy' list-group-policies --group-name $group

    echo running:
    echo aws --profile $ORG'_'$APP'_all_idy' iam get-group-policy --group-name $group --policy-name $group'_policy'
    aws --profile $ORG'_'$APP'_all_idy' iam get-group-policy --group-name $group --policy-name $group'_policy'

  done < <(aws iam --profile $ORG'_'$APP'_all_idy' list-groups-for-user --user-name "$USER_NAME" |
    jq -r '.Groups[]|.GroupName')

  export EXIT_CODE="0"
}
