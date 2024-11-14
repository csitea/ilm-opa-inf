# src/make/clean-install-dockers.func.mk
# only the clean install dockers calls here ...
# TODO: figure a more elegant and generic way to avoid this copy paste ...
#

APP_PORT=""


.PHONY: clean-install-devops-local-dev  ## @-> setup the whole local devops environment no cache
clean-install-devops-local-dev:
	$(call build-img,devops-local-dev,--no-cache,${APP_PORT})
	make start-devops-local-dev

.PHONY: install-devops-local-dev  ## @-> setup the whole local devops environment
install-devops-local-dev:
	$(call build-img,devops-local-dev,,${APP_PORT})
	make start-devops-local-dev

.PHONY: start-devops-local-dev  ## @-> setup the whole local devops-local-dev environment for python no cache
start-devops-local-dev:
	$(call start-img,devops-local-dev,--no-cache,${APP_PORT})
