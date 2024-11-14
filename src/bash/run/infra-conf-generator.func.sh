#!/bin/bash

# (2210280542) This function passes all environment variables (with exception of PATH and perhaps future exceptions)
# to tpl-gen-tpl-gen container when calling do-tpl-gen, since now it supports overriding of variables
# when they're defined from environment or passed during runtime.
do_tpl_gen() {
  env >/tmp/env.tmp
  environment=""
  #while IFS='=' read -r line; do
  #    key=$(echo ${line} | awk -F"=" '{print$1}')
  #    value=$(echo ${line} | awk -F"=" '{print$2}')
  #
  #    # ideally we do not want to mess with these docker variables
  #    if [[ ${key} == "PATH" ||  ${key} == "SHELL" || ${key} == "PWD" || ${key} == "HOME" || ${key} == "USER" || ${key} == "GIT_SSH_COMMAND" ]]
  #    then
  #        continue
  #    fi
  #    # docker cli syntax ::: -e KEY=VALUE
  #    environment="${environment} -e ${key}=${value} "
  #done </tmp/env.tmp

  # new docker exec will not persist this env
  docker exec -e ORG=${ORG} -e APP=${APP} -e ENV=${ENV} ${ORG}-tpl-gen-tpl-gen-con make tpl-gen
  export EXIT_CODE=0
}
