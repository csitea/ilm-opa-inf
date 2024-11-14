.PHONY: do-k8s-ansible-aufs ## @-> run ansible to fix the aufs storage to enable debug put -vvv after ansible-playbook
do-k8s-ansible-aufs: demand_var-ORG demand_var-APP  demand_var-ENV demand_var-PROJ_PATH
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) $(ORG)-$(APP)-infra-app-tf-runner-con /bin/bash -c 'ORG=${ORG} APP=${APP} ENV=${ENV} ./run -a do_ansible_init_for_k8s_aufs_storage'
	echo docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) $(ORG)-$(APP)-infra-app-tf-runner-con /bin/bash -c 'ansible-playbook -vvv -i ${PROJ_PATH}/cnf/k8s/v1.25/inventory.ini --private-key=~/.ssh/.spe/${ORG}-${APP}-${ENV}.k8s.aws_eks_node_group.pk ${PROJ_PATH}/cnf/k8s/v1.25/fix-aufs-storage.yaml'
