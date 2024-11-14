
# $ORG-$APP MAINTENANCE AND OPERATIONS GUIDE

## INSTALLATION & SETUP

sudo -iu www-data bash -c "mkdir -p /var/www/.gcp/.$ORG/"
sudo mkdir -p /var/www/.gcp/.$ORG/ && sudo chown -R www-data:www-data /var/www/.gcp
cd /var/www/.gcp


## RUNTIME STATES CHANGES
sudo systemctl restart nginx ; sudo systemctl status nginx
sudo systemctl restart php7.4-fpm


## CONFIGURATION CHANGES
/var/www/html/wp-config.php
/var/www/html/wp-settings.php
~/.gcp./.$ORG/$ORG-$APP-${ENV}-sa-compute-instance.json


## BINARY CONFIGURATION CHANGES
cd /var/www/html # even as the debian user
wp plugin activate advanced-custom-fields
wp plugin status advanced-custom-fields


## LOG FILES
/var/log/nginx/error.log
/var/log/nginx/access.log
/var/www/html/wp-content/debug.log

## CLOUD ACCESS
gsutil ls gs://$ORG-$APP-${ENV}-site
curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email" -H "Metadata-Flavor: Google"


## ON THE CONTAINER
```bash

# authenticate with the
export ENV=dev
gcloud auth login --cred-file=/home/appusr/.gcp/.$ORG/key-$ORG-$APP-${ENV}.json
export PROJECT_ID=$ORG-$APP-${ENV} ; gcloud config set project ${PROJECT_ID:-}

# Grant Storage Admin role to the service account for the specific bucket
gsutil iam ch serviceAccount:sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com:roles/storage.admin gs://$ORG-$APP-${ENV}-site


gcloud projects get-iam-policy ${PROJECT_ID:-}   --flatten="bindings[].members"   --format='table(bindings.role)'   --filter="bindings.members:serviceAccount:sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com"


echo $?
gsutil iam get gs://$ORG-$APP-${ENV}-site
gsutil iam get gs://$ORG-$APP-${ENV}-site > /opt/$ORG/$ORG-$APP/$ORG-$APP-inf/dat/log/gsutil-iam-get-gs.log
gcloud services enable storage.googleapis.com
# Grant Storage Object Viewer role to the service account for the specific bucket
gsutil iam ch serviceAccount:sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com:roles/storage.objectViewer gs://$ORG-$APP-${ENV}-site
echo $?
gsutil ls gs://$ORG-$APP-${ENV}-site
export REGION="europe-north1"
gcloud config set compute/region ${REGION:-}
gsutil ls -L -b gs://$ORG-$APP-${ENV}-site



# on the container
# /home/debian/.gcp/.$ORG/ has to exist on the box
export ENV=prd;
gcloud auth login --cred-file=/home/appusr/.gcp/.$ORG/key-$ORG-$APP-${ENV}.json
export PROJECT_ID=$ORG-$APP-${ENV} ; gcloud config set project ${PROJECT_ID:-}

# Set the project ID
export PROJECT_ID="$ORG-$APP-${ENV}"
gcloud config set project ${PROJECT_ID}

# Create the service account key file
gcloud iam service-accounts keys create /home/appusr/.gcp/.$ORG/$ORG-$APP-${ENV}-sa-compute-instance.json \
  --iam-account sa-compute-instance@${PROJECT_ID}.iam.gserviceaccount.com

# Set the environment variable for the service account key
export GOOGLE_APPLICATION_CREDENTIALS="/home/appusr/.gcp/.$ORG/$ORG-$APP-${ENV}-sa-compute-instance.json"




# Authenticate using the service account key
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

# Verify access to the bucket
gsutil ls gs://$ORG-$APP-${ENV}-site

# You are running on a Google Compute Engine virtual machine.
# It is recommended that you use service accounts for authentication.

# You can run:

#   $ gcloud config set account `ACCOUNT`

# to switch accounts if necessary.

# Your credentials may be visible to others with access to this
# virtual machine. Are you sure you want to authenticate with
# your personal account?

# Do you want to continue (Y/n)?  Y


# You are already authenticated with 'sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com'.
# Do you wish to proceed and overwrite existing credentials?

# Do you want to continue (Y/n)?  Y

# how-to activate the service account
export ORG=$ORG APP=$APP ENV=tst
export KEY_FILE=$(eval echo "~/.gcp/.${ORG}/key-${ORG}-${APP}-${ENV}.json")
gcloud auth activate-service-account ${ORG}-${APP}-${ENV}@${ORG}-${APP}-${ENV}.iam.gserviceaccount.com --key-file=${KEY_FILE}

# Granting the IAM Service Account Admin role to your user/service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$USER_ACCOUNT" \
    --role="roles/iam.serviceAccountAdmin"

# INTERACTIVE delete the sa-compute-instance
gcloud iam service-accounts delete sa-compute-instance@${ORG}-${APP}-${ENV}.iam.gserviceaccount.com


# SILENT delte the sa-compute-instance
SERVICE_ACCOUNT="sa-compute-instance@${ORG}-${APP}-${ENV}.iam.gserviceaccount.com"

# Use expect to handle the prompt
/usr/bin/expect <<EOF
spawn gcloud iam service-accounts delete ${SERVICE_ACCOUNT}
expect "Do you want to continue (Y/n)?"
send "Y\r"
expect eof
EOF


# activate the sa-computer-instance account
export ORG=ilm APP=opa ENV=tst
export KEY_FPATH_SA_VM=$(eval echo "~/.gcp/.${ORG}/${ORG}-${APP}-${ENV}-sa-compute-instance.json")
gcloud auth activate-service-account sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com --key-file=${KEY_FPATH_SA_VM}

gsutil uniformbucketlevelaccess set off gs://$ORG-$APP-${ENV}-site


cat /home/appusr/.gcp/.$ORG/key-$ORG-$APP-${ENV}.json | grep client_email


gcloud auth activate-service-account sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com --key-file=/home/appusr/.gcp/.$ORG/$ORG-$APP-${ENV}-sa-compute-instance.json

gsutil ls -L -b gs://$ORG-$APP-${ENV}-site/

find /opt -name '*.sh' | grep -i pdf
nslookup 34.88.79.194
nslookup $ORG.$APP.${ENV}.ilmatarbrain.com

```

## WORK WITH BUCKETS

```sh
# how-to auth against a tgt env
export ORG=$ORG APP=$APP TGT_ENV=tst ; gcloud auth activate-service-account --key-file=$(eval echo ~/.gcp/.$ORG/key-${ORG}-${APP}-${TGT_ENV}.json)

# how-to wipe out the whole bucket
export ORG=$ORG APP=$APP TGT_ENV=tst BUCKET="gs://$ORG-$APP-$TGT_ENV-site" ; gsutil -m rm -r "${BUCKET}/**"
```

## how-to switch on the www-data user os login

```sh
#!/bin/bash

# Enable the bash shell for www-data user
sudo chsh -s /bin/bash www-data

# Verify the change
sudo grep www-data /etc/passwd

echo "www-data user is now enabled with bash shell"

```
## how-to switch off the www-data user os login

```sh
#!/bin/bash

# Revert the www-data user to nologin shell
sudo chsh -s /usr/sbin/nologin www-data

# Verify the change
sudo grep www-data /etc/passwd

echo "www-data user is now reverted to nologin shell"


```
