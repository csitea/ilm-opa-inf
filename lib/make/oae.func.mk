.PHONY: new-issue ## @-> 99.99 prints new issueid
new-issue:
	# @clear
	@echo ==================================
	@echo "Issue number: `date +%y%m%d%H%M%S`"
	@echo ==================================

.PHONY: oae ## @-> prints supported OAE alternatives
oae:
	@source lib/bash/funcs/oae.func.sh
	@oae
