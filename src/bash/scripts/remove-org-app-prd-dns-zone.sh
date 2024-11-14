#!/bin/bash

ORG="str"
APP="mmp"
GCP_SA_EMAIL="ilm-opa-prd@ilm-opa-prd.iam.gserviceaccount.com"

# Set the gcloud project
gcloud config set project "$ORG-$APP-prd"

# Add IAM policy binding for DNS admin role
gcloud projects add-iam-policy-binding "$ORG-$APP-prd" \
  --member="serviceAccount:$GCP_SA_EMAIL" \
  --role="roles/dns.admin"

# Set the environment variables
export PRD_ZONE="ilm-opa-prd-subzone"

# List of common DNS record types to delete
RECORD_TYPES=("A" "AAAA" "CNAME" "MX" "TXT" "SRV" "PTR")

# Traverse and delete DNS records of each specified type
for RECORD_TYPE in "${RECORD_TYPES[@]}"; do
  gcloud dns record-sets list --zone="${PRD_ZONE}" \
    --format="value(name,type,rrdatas,ttl)" \
    --filter="type=${RECORD_TYPE}" | while read -r RECORD_NAME RECORD_TYPE RRDATAS TTL; do
    gcloud dns record-sets transaction start --zone="${PRD_ZONE}"
    gcloud dns record-sets transaction remove "${RRDATAS}" \
      --name="${RECORD_NAME}" --type="${RECORD_TYPE}" --ttl="${TTL}" --zone="${PRD_ZONE}"
    gcloud dns record-sets transaction execute --zone="${PRD_ZONE}"
  done
done

# Delete NS records last
gcloud dns record-sets list --zone="${PRD_ZONE}" \
  --format="value(name,type,rrdatas,ttl)" \
  --filter="type=NS" | while read -r RECORD_NAME RECORD_TYPE RRDATAS TTL; do
  gcloud dns record-sets transaction start --zone="${PRD_ZONE}"
  gcloud dns record-sets transaction remove "${RRDATAS}" \
    --name="${RECORD_NAME}" --type="${RECORD_TYPE}" --ttl="${TTL}" --zone="${PRD_ZONE}"
  gcloud dns record-sets transaction execute --zone="${PRD_ZONE}"
done

# Finally delete the SOA record
gcloud dns record-sets list --zone="${PRD_ZONE}" \
  --format="value(name,type,rrdatas,ttl)" \
  --filter="type=SOA" | while read -r RECORD_NAME RECORD_TYPE RRDATAS TTL; do
  gcloud dns record-sets transaction start --zone="${PRD_ZONE}"
  gcloud dns record-sets transaction remove --zone="${PRD_ZONE}" \
    --name="${RECORD_NAME}" --type="${RECORD_TYPE}" --ttl="60" --rrdatas="${RRDATAS}"
  gcloud dns record-sets transaction execute --zone="${PRD_ZONE}"
done
