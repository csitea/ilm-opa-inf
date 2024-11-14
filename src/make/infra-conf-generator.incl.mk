# usage: include it in your Makefile by:
# include lib/make/tpl-gen.mk

.PHONY: do-tpl-gen ## @-> apply the environment cnf file into the templates
do-tpl-gen: demand_var-ENV demand_var-ORG demand_var-APP
	@source src/bash/run/tpl-gen.func.sh
	@do_tpl_gen
