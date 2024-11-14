

.PHONY: do-provision-121-csi-gcp-wpb-vm ## @-> run the provision step 121-csi-gcp-wpb-vm
do-provision-121-csi-gcp-wpb-vm: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=121-csi-gcp-wpb-vm -e ACTION=provision -e SRC=/opt/$(ORG)/$(ORG)-$(APP)-infra-app -e TGT=/opt/$(ORG)/$(ORG)-$(APP)-infra-conf $(PROJ)-tf-runner-con ./run -a do_provision


.PHONY: do-divest-121-csi-gcp-wpb-vm ## @-> run the divest step 121-csi-gcp-wpb-vm
do-divest-121-csi-gcp-wpb-vm: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=121-csi-gcp-wpb-vm -e ACTION=divest $(PROJ)-tf-runner-con ./run -a do_provision


.PHONY: do-provision-130-bas-wpb-gcp-vm ## @-> run the provision step 130-bas-wpb-gcp-vm
do-provision-130-bas-wpb-gcp-vm: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=130-bas-wpb-gcp-vm -e ACTION=provision -e SRC=/opt/$(ORG)/$(ORG)-$(APP)-infra-app -e TGT=/opt/$(ORG)/$(ORG)-$(APP)-infra-conf $(PROJ)-tf-runner-con ./run -a do_provision


.PHONY: do-divest-130-bas-wpb-gcp-vm ## @-> run the divest step 130-bas-wpb-gcp-vm
do-divest-130-bas-wpb-gcp-vm: demand_var-ENV demand_var-ORG demand_var-APP
	docker exec -e ORG=$(ORG) -e APP=$(APP) -e ENV=$(ENV) -e STEP=130-bas-wpb-gcp-vm -e ACTION=divest $(PROJ)-tf-runner-con ./run -a do_provision
