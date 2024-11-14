#!/bin/bash

echo "SCRIPT START ONCE AGAIN"

# Define variables
export ORG="csi"
export APP="wpb"
export ENV="all"
export PROJECT_ID="${ORG}-${APP}-${ENV}"
# example: sa-compute-instance@ilm-opa-dev.iam.gserviceaccount.com
export COMPUTE_SA="sa-compute-instance"
export COMPUTE_SA_EMAIL="${COMPUTE_SA}@${PROJECT_ID}.iam.gserviceaccount.com"
export ADMIN_KEY_PATH=/home/ysg/.gcp/.$ORG/key-$ORG-$APP-$ENV.json
export SERVICE_ACCOUNT_KEY_PATH="/home/ysg/.gcp/.$ORG/${PROJECT_ID}-${COMPUTE_SA}.json"
export RDB_BUCKET_NAME="${PROJECT_ID}-db"
export WEB_BUCKET_NAME="${PROJECT_ID}-site"

# Create the GCP secrets directory if it doesn't exist
mkdir -p /home/ysg/.gcp/.csi || true

# # Authenticate with Google Cloud using the admin credential file
gcloud auth activate-service-account --key-file="${ADMIN_KEY_PATH}"

# Set the Google Cloud project
gcloud config set project ${PROJECT_ID}

# # (Optional) Re-create the service account if needed
# gcloud iam service-accounts delete "${COMPUTE_SA_EMAIL}" --quiet || true

# gcloud iam service-accounts create "${COMPUTE_SA}" \
#   --description="WordPress Compute Instance Service Account" \
#   --display-name="WordPress Compute Instance Service Account"

# # Create the service account key file
# gcloud iam service-accounts keys create "${SERVICE_ACCOUNT_KEY_PATH}" \
#   --iam-account="${COMPUTE_SA_EMAIL}"

# Assign necessary roles to the service account using the admin account
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${COMPUTE_SA_EMAIL}" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${COMPUTE_SA_EMAIL}" \
  --role="roles/storage.objectViewer"

gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:objectViewer gs://${RDB_BUCKET_NAME:-}
gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:objectViewer gs://${RDB_BUCKET_NAME:-}

# Apply roles at the bucket level
gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:roles/storage.objectViewer gs://${RDB_BUCKET_NAME}
gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:roles/storage.admin gs://${RDB_BUCKET_NAME}
gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:roles/storage.objectViewer gs://${WEB_BUCKET_NAME}
gsutil iam ch serviceAccount:${COMPUTE_SA_EMAIL}:roles/storage.admin gs://${WEB_BUCKET_NAME}

# # After assigning roles, switch to the service account if needed
gcloud auth activate-service-account --key-file="${SERVICE_ACCOUNT_KEY_PATH}"

# Verify access to the bucket (still authenticated as the admin account)
gsutil uniformbucketlevelaccess set off gs://"${RDB_BUCKET_NAME}"
gsutil uniformbucketlevelaccess get gs://"${RDB_BUCKET_NAME}"
gsutil uniformbucketlevelaccess set off gs://"${WEB_BUCKET_NAME}"
gsutil uniformbucketlevelaccess get gs://"${WEB_BUCKET_NAME}"

# List the contents of the bucket to verify permissions
gsutil ls gs://"${RDB_BUCKET_NAME}"
gsutil ls gs://"${WEB_BUCKET_NAME}"

# # Print success message
# echo "Service account setup and permissions are successfully configured."

gcloud auth activate-service-account --key-file="${ADMIN_KEY_PATH}"

# Verify current roles assigned to the service account
gcloud projects get-iam-policy ${PROJECT_ID} \
  --flatten="bindings[].members" \
  --format="table(bindings.role)" \
  --filter="bindings.members:${COMPUTE_SA_EMAIL}"

# Add Storage Object Viewer role if not already assigned
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${COMPUTE_SA_EMAIL}" \
  --role="roles/storage.objectViewer"

# Add Storage Admin role if broader permissions are needed
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${COMPUTE_SA_EMAIL}" \
  --role="roles/storage.admin"
