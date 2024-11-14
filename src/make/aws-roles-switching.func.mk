.PHONY: do-generate-aws-admin-role-switching ## @-> generate admin role switching credentials
do-generate-aws-admin-role-switching: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e ENV=$(ENV) -e APP=$(APP) ${PROJ}-tf-runner-con ./run -a do_generate_aws_admin_roles_switching

.PHONY: do-generate-aws-role-switching ## @-> generate role switching credentials
do-generate-aws-role-switching: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e ENV=$(ENV) -e APP=$(APP) ${PROJ}-tf-runner-con ./run -a do_generate_aws_roles_switching
