#!/bin/bash

# $1 = 'ec2 describe-vpcs' or 'ec2 describe-subnets' or etc...
# $2 = us-east-1
# $3 = aws_vpc_091_jenkins
# returns
#  {
#    "vpcid": the-actual-vpc-id-from-aws
#  }
command="aws $1 --region $2 --filters Name=tag:Name,Values=$3 | jq -c '$4'"
resource=$(eval $command)
jq -n -R --arg resource $resource "{\"resource\": $resource}"
