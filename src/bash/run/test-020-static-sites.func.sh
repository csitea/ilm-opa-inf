#!/bin/env bash

do_test_020_static_sites() {

  do_export_json_section_vars "$PROJ_PATH/cnf/env/${ORG:-}/${APP:-}/${ENV:-}.env.json" '.env.aws'
  do_export_json_section_vars "$PROJ_PATH/cnf/env/${ORG:-}/${APP:-}/${ENV:-}.env.json" '.env.app'

  case "${ENV:-}" in
  'dev') url='https://'"${ORG:-}.${APP:-}.${ENV:-}.${DOMAIN:-}"'/' ;;
  'tst') url='https://'"${ORG:-}.${APP:-}.${ENV:-}.${DOMAIN:-}"'/' ;;
  'prd') url='https://'"${ORG:-}.${APP:-}.${DOMAIN:-}"'/' ;;
  'all') url='https://'"${ORG:-}.${APP:-}.${DOMAIN:-}"'/' ;;
  *) echo 'FATAL unknown "{ENV:-} : "'${ENV:-}'"' ;;
  esac

  echo running curl --max-time 3 -s "$url" -o /dev/null -w '%{http_code}\n' -s
  curl --max-time 3 -s "$url" -o /dev/null -w '%{http_code}\n' -s
  rv=$?
  test $rv == "0" && export EXIT_CODE=0

  case "${rv:-}" in
  "0") echo "test passed the url: $url exists and returns 200 !!!" ;;
  *) echo 'the test failed !!!' ;;
  esac
}
