#!/bin/bash

function do_list_eks_worker_ips() {

  export AWS_PROFILE="${ORG}_${APP}_${ENV}_rcr"

  # workaround non-Name tag having ec2's only
  # TODO: this WILL brake stuff sooner or later ... need to be able to:
  # - either tag by eks name or
  # - fetch via the worker group and than fetch the ips
  aws ec2 describe-instances --query 'Reservations[*].Instances[*]' |
    jq -r '.[] | .[] | select( any(.Tags[]; .Key != "Name") ) | .PrivateIpAddress'

  export EXIT_CODE="0"
}
