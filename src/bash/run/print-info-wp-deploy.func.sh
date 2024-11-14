#!/bin/bash

do_print_info_wp_deploy() {

  # Setting the requirements
  do_require_var ORG ${ORG:-}
  do_require_var APP ${APP:-}
  do_require_var ENV ${ENV:-}
  do_require_var DOMAIN ${DOMAIN:-}

  # Print logs
  do_log "your wordpress UI should be accessible at:
   http://$DOMAIN
   "
  do_log "Wordpress admin is accessible at:
   http://$DOMAIN/wp-login.php
   "
  do_log "Connect with SSH like this:
   ssh -i ~/.ssh/$ORG-$APP-$ENV-csi_wpb_cms.pk ubuntu@$DOMAIN
   "
  export EXIT_CODE=$?

}
