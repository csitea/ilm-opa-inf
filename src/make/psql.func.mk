# altough it is possible to install psql, docker cannot see VPN
# thus cannot connect to RDS
.PHONY: psql-create-db-microservice-user ## @-> create psql microservice user
psql-create-db-microservice-user: demand_var-ENV demand_var-ORG demand_var-APP demand_var-MICROSERVICE_USER demand_var-MICROSERVICE_USER_PW
	# # @clear
	# docker exec \
	# -e ORG=$(ORG) \
	# -e ENV=$(ENV) \
	# -e APP=$(APP) \
	# -e AWS_PROFILE=$(AWS_PROFILE) \
	# -e GITHUB_TOKEN=$(GITHUB_TOKEN) \
	# -e MICROSERVICE_USER=${MICROSERVICE_USER} \
	# -e MICROSERVICE_USER_PW=${MICROSERVICE_USER_PW} \
	# ${PROJ}-tf-runner-con ./run -a do_psql_create_db_microservice_user

	# @clear
	./run -a do_psql_create_db_microservice_user

.PHONY: psql-alter-db-microservice-user ## @-> alter db microservice user
psql-alter-db-microservice-user: demand_var-ENV demand_var-ORG demand_var-APP demand_var-MICROSERVICE_USER demand_var-MICROSERVICE_USER_PW
	./run -a do_psql_alter_db_microservice_user

.PHONY: psql-create-db ## @-> create app db
psql-create-db: demand_var-ENV demand_var-ORG demand_var-APP demand_var-POSTGRES_APP_DB demand_var-MICROSERVICE_USER
	./run -a do_psql_create_db

.PHONY: psql-alter-db-microservice-user-password ## @-> alter db microservice user's password
psql-alter-db-microservice-user-password: demand_var-ENV demand_var-ORG demand_var-APP demand_var-MICROSERVICE_USER demand_var-MICROSERVICE_USER_PW
	./run -a do_psql_alter_db_microservice_user_password

.PHONY: psql-drop-db-microservice-user ## @-> drop db microservice user
psql-drop-db-microservice-user: demand_var-ENV demand_var-ORG demand_var-APP demand_var-MICROSERVICE_USER
	./run -a do_psql_drop_db_microservice_user

.PHONY: psql-drop-db ## @-> drop app db
psql-drop-db: demand_var-ENV demand_var-ORG demand_var-APP demand_var-POSTGRES_APP_DB
	./run -a do_psql_drop_db
