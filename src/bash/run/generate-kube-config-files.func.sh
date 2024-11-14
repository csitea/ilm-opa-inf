#!/bin/bash

do_generate_kube_config_files() {

  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}

  export AWS_REGION=us-east-1
  org=$ORG
  app=$APP
  test -f ~/.kube/config && mv -v ~/.kube/config ~/.kube/config.$(date "%Y%m%d%H%M%S").bak

  while read -r env; do

    unset KUBECONFIG
    # echo running:
    # echo aws eks --profile "$org"_"$app"_"$env"_rcr --region '${AWS_REGION:-}' update-kubeconfig --name eks-cluster-"$org"-"$app"-"$env" --alias 'eks-cluster-'"$org"-"$app"-"$env"
    # aws eks --profile "$org"_"$app"_"$env"_rcr --region '${AWS_REGION:-}' update-kubeconfig --name eks-cluster-"$org"-"$app"-"$env" --alias 'eks-cluster-'"$org"-"$app"-"$env"
    # if [[ ! -f ~/.kube/config ]]; then
    #   do_log ERROR could generate the ~/.kube/config
    #     continue
    # fi

    # mv -v ~/.kube/config ~/.kube/config.$org.$app.$env.adm
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
