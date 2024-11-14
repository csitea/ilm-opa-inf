# file: src/make/install-img-psql-client.func.mk
# Keep all (clean and regular) docker install functions in here.

SHELL=bash
PROJ:=$(shell basename $$PWD)
product:=$(shell echo `basename $$PWD`|tr '[:upper:]' '[:lower:]')

PSQL_CLIENT_PORT=


.PHONY: clean-install-psql-client  ## @-> setup the whole local devops environment no cache
clean-install-psql-client:
	$(call build-img,psql-client,--no-cache,${PSQL_CLIENT_PORT})


.PHONY: install-psql-client  ## @-> setup the whole local devops environment
install-psql-client:
	$(call build-img,psql-client,,${PSQL_CLIENT_PORT})


# file: src/make/install-img-psql-client.func.mk
