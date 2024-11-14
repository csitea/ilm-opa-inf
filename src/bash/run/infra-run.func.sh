#!/bin/bash
do_infra_run() {

  # executes provision or divest step in a tmux window

  ACTION=$1
  STEP=$2
  DEPENDENCY=${3:-}

  if [[ "${DEPENDENCY}" != "" ]]; then
    ORG=${ORG} APP=${APP} ENV=${ENV} make do-${ACTION}-${3}
  fi

  #do_log "INFO Running: ${STEP} on tmux session ::: "
  #echo "  tmux attach-session -t ${ORG}-${APP}-${ENV}-${ACTION}-${STEP}"
  #echo "  tail -f ./${ORG}-${APP}-${ENV}-${ACTION}-${STEP}.log"
  #echo
  tmux new -s "${ORG}-${APP}-${ENV}-${ACTION}-${STEP}" -d
  tmux send-keys -t ${ORG}-${APP}-${ENV}-${ACTION}-${STEP}.0 $(ORG=${ORG} APP=${APP} ENV=${ENV} make do-${ACTION}-${STEP} &>${ORG}-${APP}-${ENV}-${ACTION}-${STEP}.log) ENTER
}
