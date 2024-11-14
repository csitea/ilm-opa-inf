#!/bin/bash

do_test_url_list() {

  do_require_var LINKS_LIST_FILE $LINKS_LIST_FILE
  while read -r url; do

    # Send request and capture the HTTP status code
    HTTP_STATUS=$(curl -o /dev/null -s --max-time 5 \
      -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" \
      -w "%{http_code}" $url)

    # Check the status code and display the appropriate message
    if [[ "${HTTP_STATUS}" -eq 200 ]]; then
      echo -e "$url;OK"
    else
      echo -e "$url;NOK"
    fi

  done < <(cat ${LINKS_LIST_FILE:-} | sort)

  export EXIT_CODE="0"
}
