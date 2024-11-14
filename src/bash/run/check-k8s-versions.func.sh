#!/bin/bash

do_check_k8s_versions() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}

  export AWS_REGION='us-east-1'
  org=$ORG
  app=$APP
  test -f ~/.kube/config && mv -v ~/.kube/config ~/.kube/config.$(date "%Y%m%d%H%M%S").bak

  while read -r env; do

    k8s_cluster=$(aws eks --profile "$org"_"$app"_"$env"_rcr --region $AWS_REGION list-clusters | jq -r '.clusters[]' | head -n 1)
    k8s_cluster_version=$(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name $k8s_cluster | jq -r '.cluster.version')
    echo running:
    echo cluster: \$\(aws eks --profile "$org"_"$app"_"$env"_rcr --region $AWS_REGION list-clusters \| jq -r '.clusters[]'\|head -n 1\), version:\$\(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name \$\(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name $k8s_cluster\|jq -r '.cluster.version'\)\|jq -r '.cluster.version'\)
    echo cluster: $k8s_cluster, version:$k8s_cluster_version

  done < <(
    cat <<EOF_ENVS
   dev
   tst
   stg
   all
EOF_ENVS
  )

  export EXIT_CODE="0"

}
