#!/bin/bash
#
#
do_get_microservices_versions_from_k8s() {

  while read -r s; do
    echo start ::: service deployment: $s
    echo kubectl -n apiv2 get deployment $s -o json
    git_hash=$(kubectl -n apiv2 get deployment $s -o json |
      jq -r '.spec.template.spec.containers[].image' | head -n 1 | cut -d: -f2 | xargs)
    echo git_hash: $git_hash
    # for this to work the local .git must be update to date, todo:<<org>> param
    # export GIT_SSH_COMMAND="ssh -p 22 -i ~/.ssh/id_rsa.spe";
    #git checkout master ; git pull --rebase
    cd /opt/spe/se-backend-default
    version=$(git show-ref --tags | grep -i $git_hash | cut -d/ -f3 | xargs)
    cd -
    echo git show-ref tags\|grep -i $git_hash\|cut -d/ -f3\|xargs
    echo git show-ref --tags | grep -i $git_hash | cut -d'/' -f2
    echo deployment: $s , version: $version
    echo stop ::: service deployment : $s
  done < <(kubectl -n apiv2 get deployments -o json | jq -r '.items[]|.metadata.name')

  export EXIT_CODE="0"

  data=$(
    cat <<EOF_DATA_01
{
  "apps": [
    [
EOF_DATA_01
    #      {
    #        "name": "eks-cluster-tqa-wph-dev",
    #        "arn": "arn:aws:eks:us-east-1:817680717920:cluster/eks-cluster-tqa-wph-dev",
    #        "tags": {
    #          "APP": "skk",
    #          "VERSION": "1.2.2",
    #          "ENV": "dev",
    #          "INFRA_VERSION": "1.9.8",
    #
    #          "CNF_VER": "6868c52"
    #        }
    #      },
    #    ],
    #    [
    #      {
    #        "name": "eks-cluster-spe-tbt-dev",
    #        "arn": "arn:aws:eks:us-east-1:817680717920:cluster/eks-cluster-spe-tbt-dev",
    #        "tags": {
    #          "APP": "tbt",
    #          "TERRAFORM_VERSION": "1.2.2",
    #          "ENV": "dev",
    #          "INFRA_VERSION": "1.7.2",
    #
    #          "CNF_VER": "6868c52"
    #        }
    #      },
    #    ]
    #  ]
    #}
    #EOF_DATA_01

    while read -r s; do
      echo start ::: service deployment: $s
      echo kubectl -n apiv2 get deployment $s -o json
      git_hash=$(kubectl -n apiv2 get deployment $s -o json |
        jq -r '.spec.template.spec.containers[].image' | head -n 1 | cut -d: -f2 | xargs)
      echo git_hash: $git_hash
      # for this to work the local .git must be update to date, todo:<<org>> param
      # export GIT_SSH_COMMAND="ssh -p 22 -i ~/.ssh/id_rsa.spe";
      #git checkout master ; git pull --rebase
      cd /opt/spe/se-backend-default
      version=$(git show-ref --tags | grep -i $git_hash | cut -d/ -f3 | xargs)
      cd -
      echo git show-ref tags\|grep -i $git_hash\|cut -d/ -f3\|xargs
      echo git show-ref --tags | grep -i $git_hash | cut -d'/' -f2
      echo deployment: $s , version: $version
      echo stop ::: service deployment : $s
    done < <(kubectl -n apiv2 get deployments -o json | jq -r '.items[]|.metadata.name')

    export EXIT_CODE="0"

    EOF_DATA_01
  )

}
