#!/bin/bash
#you need AWSCLI and Docker installed to run this command

do_upload_infra_tags_api_img_to_ecr() {
  #build image
  cd /opt/spe/spe-e2e-mon && make build-img-infra-tags-api

  # Set the account name you want to search for
  account_name="$ORG-$APP-all-rcr"

  # Set the path to your YAML file
  yaml_file="$BASE_PATH/$ORG/$ORG-$APP-infra-conf/$APP/all-org-app-aws-accounts.yaml"

  # Use yq to search for the account ID
  org_app_env_all_rcr_aws_acc_id=$(yq -r --arg name "$account_name" '.org_aws_accounts[] | select(.aws_account_name == $name) | .aws_account_id' "$yaml_file")

  # Print the account ID
  echo $org_app_env_all_rcr_aws_acc_id

  AWS_REGION=${AWS_REGION:-us-east-1}

  #docker login for AWS
  docker login -u AWS -p $(aws ecr get-login-password --region $AWS_REGION --profile ${ORG}_${APP}_all_rcr) ${org_app_env_all_rcr_aws_acc_id}.dkr.ecr.$AWS_REGION.amazonaws.com

  #tagging docker image
  ECR_NAME="spectralha-api/infra-tags-api"
  docker tag spe-e2e-mon-infra-tags-api-img:latest ${org_app_env_all_rcr_aws_acc_id}.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_NAME:latest

  #upload image into ERC
  docker push ${org_app_env_all_rcr_aws_acc_id}.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_NAME:latest

  #delete all untaged images
  IMAGES_TO_DELETE=$(aws ecr list-images --profile ${ORG}_${APP}_all_rcr --region $AWS_REGION --repository-name $ECR_NAME --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json | jq -r '.[] | "imageDigest=\(.imageDigest)"')
  aws ecr batch-delete-image --profile ${ORG}_${APP}_all_rcr --region $AWS_REGION --repository-name $ECR_NAME --image-ids "$IMAGES_TO_DELETE" || true

  export EXIT_CODE=$?
}
