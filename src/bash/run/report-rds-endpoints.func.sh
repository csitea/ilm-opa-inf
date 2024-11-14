#!/bin/bash

do_report_rds_endpoints() {

  # Set the output file path
  OUTPUT_FILE="doc/md/reports/rds-endpoints.md"

  # Create the directory for the output file if it doesn't exist
  mkdir -p "$(dirname "${OUTPUT_FILE}")"

  # Write the table header to the output file
  echo "| Instance Identifier | Endpoint Address |" >"${OUTPUT_FILE}"
  echo "|---------------------|------------------|" >>"${OUTPUT_FILE}"

  all_output=""

  for app in $(echo skk); do for env in $(echo dev tst stg all); do
    export AWS_PROFILE='csi_'$app'_'"$env"'_rcr'
    echo running:
    echo aws rds describe-db-instances \
      --query 'DBInstances[*].[DBInstanceIdentifier,Endpoint.Address]' \
      --output text \
      --profile "${AWS_PROFILE}"
    current_output=$(aws rds describe-db-instances \
      --query 'DBInstances[*].[DBInstanceIdentifier,Endpoint.Address]' \
      --output text \
      --profile "${AWS_PROFILE}")
    all_output="${all_output}${current_output}"$'\n'

    aws rds describe-db-instances \
      --query 'DBInstances[*].[DBInstanceIdentifier,Endpoint.Address]' \
      --output text \
      --profile "${AWS_PROFILE}" |
      awk '{printf "| %s | %s |\n", $1, $2}' >>"${OUTPUT_FILE}"

  done; done

  echo -e "\n\n the list of the current rds end points: \n"
  echo "$all_output"

  export EXIT_CODE="0"
}
