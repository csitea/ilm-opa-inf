# src/make/clean-install-dockers.func.mk
# Keep all (clean and regular) docker install functions in here.

.PHONY: setup-tf-runner  ## @-> setup the whole local tf-runner environment for python no cache
setup-tf-runner:
	$(call build-img,tf-runner,--no-cache,${TPL_GEN_PORT})
	make start-tf-runner

.PHONY: setup-tf-runner-cached ## @-> setup the whole local tf-runner environment for python
setup-tf-runner-cached:
	$(call build-img,tf-runner,,${TPL_GEN_PORT})
	make start-tf-runner

.PHONY: build-tf-runner  ## @-> setup the whole local tf-runner environment for python no cache
build-tf-runner:
	$(call build-img,tf-runner,--no-cache,${TPL_GEN_PORT})

.PHONY: start-tf-runner  ## @-> setup the whole local tf-runner environment for python no cache
start-tf-runner:
	$(call start-img,tf-runner,--no-cache,${TPL_GEN_PORT})

.PHONY: stop-tf-runner
stop-tf-runner:
	CONTAINER_NAME=tf-runner
	$(call stop-and-remove-docker-container)
