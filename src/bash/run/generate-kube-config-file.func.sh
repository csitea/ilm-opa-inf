#!/bin/bash

do_generate_kube_config_file() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}

  export AWS_REGION='us-east-1'
  org=$ORG
  app=$APP
  env=$ENV
  test -f ~/.kube/config && mv -v ~/.kube/config ~/.kube/config.$(date "%Y%m%d%H%M%S").bak

  unset KUBECONFIG

  export KUBECONFIG=~/.kube/config.$org-$app-$env.adm
  test -f $KUBECONFIG && mv -v $KUBECONFIG $KUBECONFIG.bak.$(date "+%Y%m%d%H%M%S").bak

  k8s_cluster=$(aws eks --profile "$org"_"$app"_"$env"_rcr --region $AWS_REGION list-clusters | jq -r '.clusters[]' | head -n 1)
  k8s_cluster_version=$(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name $k8s_cluster | jq -r '.cluster.version')
  echo running:
  echo cluster: \$\(aws eks --profile "$org"_"$app"_"$env"_rcr --region $AWS_REGION list-clusters \| jq -r '.clusters[]'\|head -n 1\), version:\$\(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name \$\(aws eks --profile "$org"_"$app"_"$env"_rcr describe-cluster --name $k8s_cluster\|jq -r '.cluster.version'\)\|jq -r '.cluster.version'\)
  echo cluster: $k8s_cluster, version:$k8s_cluster_version

  echo "running:
  aws eks --profile $org'_'$app'_'$env'_rcr' --region $AWS_REGION update-kubeconfig --name eks-cluster-$org-$app-$env --alias eks-cluster-$org-$app-$env"
  aws eks --profile $org'_'$app'_'$env'_rcr' --region $AWS_REGION update-kubeconfig --name eks-cluster-$org-$app-$env --alias eks-cluster-$org-$app-$env

  export EXIT_CODE="$?"

}
