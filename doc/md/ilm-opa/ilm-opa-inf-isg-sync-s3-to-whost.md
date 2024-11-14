# THE ISG AND MOG FOR REMOVING THE


On the host

```sh
# how-to auth against a tgt env
export ORG=ilm APP=opa TGT_ENV=tst ;
# gcloud auth activate-service-account --key-file=$(eval echo ~/.gcp/.$ORG/key-${ORG}-${APP}-${TGT_ENV}.json)

# how-to wipe out the whole bucket
#export ORG=$ORG APP=$APP ENV=tst BUCKET="gs://$ORG-$APP-$ENV-site" ; gsutil -m rm -r "${BUCKET}/**"


# on the devops host create the
ssh -o IdentitiesOnly=yes -i ~/.ssh/.$ORG/$ORG-$APP-$ENV-wpb.pk debian@${ORG}.${APP}.${ENV}.flok.fi mkdir -p /home/debian/.gcp/.$ORG/


export KEY_FPATH_SA_VM=$(eval echo ~/.gcp/.$ORG/${ORG}-${APP}-${ENV}-sa-compute-instance.json)

scp -o IdentitiesOnly=yes -i ~/.ssh/.$ORG/$ORG-$APP-$ENV-wpb.pk $KEY_FPATH_SA_VM debian@${ORG}.${APP}.${ENV}.flok.fi:/home/debian/.gcp/.$ORG/



```
go to the server

```sh
ssh -o IdentitiesOnly=yes -i ~/.ssh/.$ORG/$ORG-$APP-$ENV-wpb.pk debian@${ORG}.${APP}.${ENV}.flok.fi


```
on the server

```sh
export ORG=ilm APP=opa ENV=tst
export KEY_FPATH_SA_VM=$(eval echo "~/.gcp/.${ORG}/${ORG}-${APP}-${ENV}-sa-compute-instance.json")
gcloud auth activate-service-account sa-compute-instance@$ORG-$APP-${ENV}.iam.gserviceaccount.com --key-file=${KEY_FPATH_SA_VM}
gsutil ls -L -b gs://${ORG}-${APP}-${ENV}-site/

#!/bin/bash

# Set the bucket and local directory variables
BUCKET="gs://${ORG}-${APP}-${ENV}-site/2024/07/"
LOCAL_DIR="/var/www/html/wp-content/uploads/"

# Get the list of files in the bucket
gsutil ls -r ${BUCKET}** | awk -F'/' '{print $NF}' | sort > /tmp/bucket_files.txt

# Find and remove files in the local directory that match names in the bucket
find ${LOCAL_DIR} -type f | while read -r local_file; do
  local_filename=$(basename "$local_file")
  if grep -qx "$local_filename" /tmp/bucket_files.txt; then
    echo "Removing $local_file"
    sudo rm -v "$local_file"
  fi
done

# Clean up temporary file
# rm /tmp/bucket_files.txt

```
