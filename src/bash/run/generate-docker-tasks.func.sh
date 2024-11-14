#!/bin/bash
do_generate_docker_tasks() {

  # bootstrap itself
  do_log "INFO generating docker provisioning tasks"
  echo '' >$PROJ_PATH/src/make/docker-provisoning-tasks.mk
  mkdir -p $PROJ_PATH/dat/tmp/
  test -f $PROJ_PATH/dat/tmp/.found-generate-docker-tasks &&
    rm -v $PROJ_PATH/dat/tmp/.found-generate-docker-tasks
  touch $PROJ_PATH/dat/tmp/.found-generate-docker-tasks

  while read -r action; do
    if grep -Fxq "$action" $PROJ_PATH/dat/tmp/.found-generate-docker-tasks; then
      echo \# found action: $action already - nothing to do
    else
      # code if not found
      cat lib/tpl/docker-task.mk | sed 's/%task%/'${action}'/g' 2>/dev/null
    fi
    echo $action >>$PROJ_PATH/dat/tmp/.found-generate-docker-tasks
  done < <(ls -1 $BASE_PATH/$ORG_DIR/*/src/terraform | egrep -v -e 'remote-bucket|modules' | sort -n) >>$PROJ_PATH/src/make/docker-provisoning-tasks.mk

  perl -pi -e 's|.PHONY|\n.PHONY|' src/make/docker-provisoning-tasks.mk

  export EXIT_CODE=0
}
