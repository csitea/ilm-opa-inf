# usage: include it in your Makefile by:
# include lib/make/make-help.task

.PHONY: do-install-terraform ## @-> checks the terraform version
do-install-terraform:
	@echo "Installing specified terraform versions ..."
	@do_install_terraform()
