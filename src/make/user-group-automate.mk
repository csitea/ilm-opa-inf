.PHONY: do-user-group-automate ## @-> generate the conf for the steps
do-user-group-automate: demand_var-ORG demand_var-APP demand_var-PROJ_PATH
	docker exec -e ORG=$(ORG) -e APP=$(APP) $(ORG)-$(APP)-infra-app-user-group-automate-con /bin/bash -c 'cd ${PROJ_PATH}/src/python/user-group-automate && poetry run start'


