.PHONY: psql-generate-scripts ## @-> generate wrappers and functions for PSQL scrips
psql-generate-scripts: demand_var-ENV demand_var-ORG demand_var-APP
	./run -a do_psql_generate_scripts