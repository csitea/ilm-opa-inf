.PHONY: do-%task% ## @-> run the %task% task
do-%task%: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e ENV=$(ENV) -e APP=$(APP) -e AWS_PROFILE=$(AWS_PROFILE) ${PROJ}-tf-runner-con ./run -a %action%
