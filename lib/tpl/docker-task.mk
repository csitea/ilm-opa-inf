.PHONY: do-provision-%task% ## @-> run the provision step %task%
do-provision-%task%: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=%task% -e ACTION=provision -e SRC=/opt/$(ORG)/$(ORG)-$(APP)-infra-app -e TGT=/opt/$(ORG)/$(ORG)-$(APP)-infra-conf $(PROJ)-tf-runner-con ./run -a do_provision

.PHONY: do-divest-%task% ## @-> run the divest step %task%
do-divest-%task%: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=%task% -e ACTION=divest $(PROJ)-tf-runner-con ./run -a do_provision
