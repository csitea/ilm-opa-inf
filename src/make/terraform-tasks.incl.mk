.PHONY: tf-new-step ## @-> generates framework for terraform new step
tf-new-step: demand_var-STEP
	./run -a do_tf_new_step

.PHONY: tf-remove-step ## @-> generates framework for terraform new step
tf-remove-step: demand_var-STEP
	./run -a do_tf_remove_step

.PHONY: do-tf-plan ## @-> saves a terraform plan
do-tf-plan: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_plan

.PHONY: do-import ## @-> import terraform resource
do-import: demand_var-AWS_PROFILE demand_var-ENV demand_var-ORG demand_var-APP demand_var-TF_PROJ demand_var-RESOURCE_ADDRESS demand_var-RESOURCE_IDENTIFIER demand_var-STEP
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e AWS_PROFILE=$(AWS_PROFILE) \
		-e RESOURCE_ADDRESS=$(RESOURCE_ADDRESS) \
		-e RESOURCE_IDENTIFIER=$(RESOURCE_IDENTIFIER) \
		-e TF_PROJ=$(TF_PROJ) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_import

.PHONY: do-provision-local ## @-> provision a step
do-provision-local: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) \
    -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_provision_local

.PHONY: do-divest-local ## @-> divest  a step only
do-divest-local: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) \
    -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_divest_local

.PHONY: do-tf-apply-target ## @-> provision target resource only
do-tf-apply-target: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e TARGET="$(TARGET)" \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_apply_target


.PHONY: do-tf-validate ## @-> check the syntax of the terraform files
do-tf-validate: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_validate


.PHONY: do-tf-destroy-target ## @-> divest target resource only
do-tf-destroy-target: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e TARGET="$(TARGET)" \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_destroy_target

.PHONY: do-tf-import ## @-> import target resource to state
do-tf-import: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-RESOURCE_ADDRESS demand_var-ID
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@echo docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		-e RESOURCE_ADDRESS="$(RESOURCE_ADDRESS)" \
		-e ID=$(ID) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_import
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		-e RESOURCE_ADDRESS="$(RESOURCE_ADDRESS)" \
		-e ID=$(ID) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_import

.PHONY: do-tf-replace-target ## @-> reprovision (destroy/recreates) terraform resource
do-tf-replace-target: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e TARGET="$(TARGET)" \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_replace_target

.PHONY: do-tf-taint-target ## @-> import terraform resource
do-tf-taint-target: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e TARGET="$(TARGET)" \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_taint_target

.PHONY: do-tf-untaint-target ## @-> import terraform resource
do-tf-untaint-target: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e TARGET="$(TARGET)" \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_untaint_target


.PHONY: do-tf-state-list ## @-> list the objects in the terraform state
do-tf-state-list: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_state_list

.PHONY: do-tf-state-pull ## @-> pull remote state from s3
do-tf-state-pull: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_state_pull

.PHONY: do-tf-state-push ## @-> push state to s3
do-tf-state-push: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TFSTATE_FILE
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		-e TFSTATE_FILE=$(TFSTATE_FILE) \
		${PROJ}-tf-runner-con \
		./run -a do_tf_state_push

.PHONY: do-tf-state-remove ## @-> remove target resource from state
do-tf-state-remove: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		-e TARGET="$(TARGET)" \
		${PROJ}-tf-runner-con \
		./run -a do_tf_state_remove

.PHONY: do-tf-state-show ## @-> remove target resource from state
do-tf-state-show: demand_var-ENV demand_var-ORG demand_var-APP demand_var-STEP demand_var-TARGET
	@ORG=$(ORG) APP=$(APP) ENV=$(ENV)
	@docker exec \
		-e ORG=$(ORG) -e SKIP_GIT_CLONE=$(SKIP_GIT_CLONE) \
		-e ENV=$(ENV) \
		-e APP=$(APP) \
		-e STEP=$(STEP) \
		-e TARGET="$(TARGET)" \
		${PROJ}-tf-runner-con \
		./run -a do_tf_state_show
