#!/bin/bash
do_infra_spinup() {
  do_log "WARNING You're about to provision a full cloud environment for:"
  do_log "WARNING Organization: ${ORG}"
  do_log "WARNING Application:  ${APP}"
  do_log "WARNING Environment:  ${ENV}"

  do_log "INFO Provisioning will start in 5 seconds ..."
  sleep 5

  ACTION=provision

  do_infra_run ${ACTION} 020-rds &
  do_infra_run ${ACTION} 050-wireguard &

  # will bind to this one due to the dependency
  do_infra_run ${ACTION} 070-coupling 030-eks
  # this means, provision 070-coupling, which has 030-eks as dependency
  # thus, provision 030-eks first

  export EXIT_CODE=0
}
