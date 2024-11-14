#!/bin/bash

do_generate_switch_aws_accounts_links() {
  test -f ~/Desktop/switch-aws-accounts-links.html && rm -v ~/Desktop/switch-aws-accounts-links.html

  # Store the command output in a variable
  output=$(aws organizations --profile rtr_adm list-accounts --output json | jq -r '[[.Accounts[]|select(.Name|test("kdm-wpb.*"))|{"aws_account_name":.Name, "aws_account_id":.Id}]| sort_by(.aws_account_name)[]|{"aws_account_name":.aws_account_name,"aws_account_id":.aws_account_id}]')

  # Iterate through the JSON array and process each account
  echo "$output" | jq -c '.[]' | while read -r account; do
    aws_account_name=$(echo "$account" | jq -r '.aws_account_name')
    aws_account_id=$(echo "$account" | jq -r '.aws_account_id')

    org=$(echo "$aws_account_name" | cut -d'-' -f 1)
    app=$(echo "$aws_account_name" | cut -d'-' -f 2)
    env=$(echo "$aws_account_name" | cut -d'-' -f 3)

    cat <<EOF | tee -a ~/Desktop/switch-aws-accounts-links.html

    [$(echo $aws_account_name)](https://signin.aws.amazon.com/switchrole?account=$aws_account_id&roleName=${env}_iam_role_root_admin&displayName=$(echo $aws_account_name))"
EOF
    test $? -ne "0" && exit 1
  done

  export EXIT_CODE="0"
}
