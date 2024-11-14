#!/bin/bash

# this is WIP - PRETTY complex - needs to be iterated several times use with CAUTION !!!!
do_remove_vpc() {

  do_require_var TGT_VPC_ID "${TGT_VPC_ID:-}"
  do_require_var ORG "${ORG:-}"
  do_require_var APP "${APP:-}"
  do_require_var ENV "${ENV:-}"

  export AWS_PROFILE="$ORG"'_'"$APP"'_'"$ENV"'_rcr'
  export AWS_REGION='us-east-1'

  echo AWS_PROFILE: $AWS_PROFILE
  echo AWS_REGION: $AWS_REGION

  #set -x
  aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$TGT_VPC_ID" --region $AWS_REGION --query 'NatGateways[?State==`available` || State==`pending`].[NatGatewayId]' --output text | while read -r nat_gateway_id; do
    echo "Deleting NAT Gateway $nat_gateway_id"
    aws ec2 delete-nat-gateway --nat-gateway-id "$nat_gateway_id" --region REGION
  done

  # Terminate all EC2 instances
  for instance_id in $(aws ec2 describe-instances --filters "Name=vpc-id,Values=$TGT_VPC_ID" --query 'Reservations[*].Instances[*].InstanceId' --output text --region $AWS_REGION); do
    echo "Terminating EC2 instance $instance_id"
    aws ec2 terminate-instances --instance-ids "$instance_id" --region $AWS_REGION
  done

  # Wait for all instances to be terminated
  # todo: should this be removed ... ?!
  # aws ec2 wait instance-terminated --filters "Name=vpc-id,Values=$TGT_VPC_ID" --region $AWS_REGION

  # Delete all VPC Peering connections
  for peer_id in $(aws ec2 describe-vpc-peering-connections --filters "Name=requester-vpc-info.vpc-id,Values=$TGT_VPC_ID" --query 'VpcPeeringConnections[*].VpcPeeringConnectionId' --output text --region $AWS_REGION); do
    echo "Deleting VPC peering connection $peer_id"
    aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id "$peer_id" --region $AWS_REGION
  done

  # Detach and delete all Internet Gateways
  for igw_id in $(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$TGT_VPC_ID" --query 'InternetGateways[*].InternetGatewayId' --output text --region $AWS_REGION); do
    echo "Detaching and deleting Internet Gateway $igw_id"
    aws ec2 detach-internet-gateway --internet-gateway-id "$igw_id" --vpc-id "$TGT_VPC_ID" --region $AWS_REGION
    aws ec2 delete-internet-gateway --internet-gateway-id "$igw_id" --region $AWS_REGION
  done

  # Delete all Subnets
  for subnet_id in $(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$TGT_VPC_ID" --query 'Subnets[*].SubnetId' --output text --region $AWS_REGION); do
    echo "Deleting Subnet $subnet_id"
    aws ec2 delete-subnet --subnet-id "$subnet_id" --region $AWS_REGION
  done

  # Delete all Route Tables
  for rt_id in $(aws ec2 describe-route-tables --query 'RouteTables[?Associations[?Main!=`true`]]' --filters "Name=vpc-id,Values=$TGT_VPC_ID" --query 'RouteTables[*].RouteTableId' --output text --region $AWS_REGION); do
    echo "Deleting Route Table $rt_id"

    associations=$(aws ec2 --region $AWS_REGION describe-route-tables --route-table-ids $rt_id --query 'RouteTables[].Associations[].AssociationId' --output text)

    # Loop through each association and delete it
    for association in $associations; do
      echo "Deleting association: $association"
      aws ec2 --region $AWS_REGION disassociate-route-table --association-id $association
    done

    aws ec2 --region $AWS_REGION delete-route-table --route-table-id "$rt_id"
  done

  # Delete all Network ACLs
  for acl_id in $(aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$TGT_VPC_ID" "Name=default,Values=false" --query 'NetworkAcls[*].NetworkAclId' --output text --region $AWS_REGION); do
    echo "Deleting Network ACL $acl_id"
    aws ec2 delete-network-acl --network-acl-id "$acl_id" --region $AWS_REGION
  done

  echo running FINALLY aws ec2 delete-vpc --vpc-id $TGT_VPC_ID --region $AWS_REGION
  aws ec2 delete-vpc --vpc-id $TGT_VPC_ID --region $AWS_REGION

  export EXIT_CODE="0"

}
