#!/bin/bash

do_list_all_dns_entries() {
  # Get a list of hosted zones in JSON format
  do_require_var ORG "${ORG:-}"
  do_require_var ENV "${ENV:-}"
  do_require_var APP "${APP:-}"
  export AWS_PROFILE=$ORG'_'$APP'_'$ENV'_rcr'

  hosted_zones=$(aws route53 list-hosted-zones)

  # Extract the hosted zone IDs and names
  zone_ids=$(echo "$hosted_zones" | jq -r '.HostedZones[].Id')
  zone_names=$(echo "$hosted_zones" | jq -r '.HostedZones[].Name')

  # Iterate through the hosted zone IDs and names
  while IFS= read -r zone_id && IFS= read -r zone_name <&3; do
    echo "Hosted Zone ID: $zone_id"
    echo "Hosted Zone Name: $zone_name"

    # Get the resource record sets for the current hosted zone
    record_sets=$(aws route53 list-resource-record-sets --hosted-zone-id "$zone_id")

    # Extract the DNS names and resource records for the current hosted zone
    dns_records=$(echo "$record_sets" | jq -r '.ResourceRecordSets[] | .Name, .ResourceRecords[]?.Value')

    # Print the DNS names and their corresponding resource records
    echo "DNS Names and Resource Records:"
    current_dns_name=""
    while read -r line; do
      if [[ $line == *" "* ]]; then
        # Line contains a resource record
        echo "Resource Record: $line"
      else
        # Line contains a DNS name
        if [[ -n $current_dns_name ]]; then
          echo "-----------------------"
        fi
        current_dns_name=$line
        echo "DNS Name: $current_dns_name"
      fi
    done <<<"$dns_records"

    echo ""
  done < <(echo "$zone_ids") 3< <(echo "$zone_names")

  export EXIT_CODE="0"
}
