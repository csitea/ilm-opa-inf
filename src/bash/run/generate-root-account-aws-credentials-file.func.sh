#!/bin/bash
do_generate_root_account_aws_credentials_file() {

  export AWS_SHARED_CREDENTIALS_FILE="$HOME"'/.aws/.'$ORG'/credentials'
  test -f "$AWS_SHARED_CREDENTIALS_FILE" && {
    do_log "INFO Nothing to do, \"$AWS_SHARED_CREDENTIALS_FILE\" file already exists."
  }

  test -f "$AWS_SHARED_CREDENTIALS_FILE" || {

    do_require_var AWS_ACCESS_KEY_ID "${AWS_ACCESS_KEY_ID:-}"
    do_require_var AWS_SECRET_ACCESS_KEY "${AWS_SECRET_ACCESS_KEY:-}"

    sudo bash -c 'mkdir -p '"$HOME"'/.aws/.'"$ORG"
    sudo bash -c 'echo '${GITHUB_TOKEN}' > '$HOME'/.aws/.'$ORG'/.github-token'

    test -z "${AWS_PROFILE:-}" && export AWS_PROFILE='rtr_adm'

    sudo bash -c 'cat > '$AWS_SHARED_CREDENTIALS_FILE' <<- EOF_AWS_CREDS
['$AWS_PROFILE']
aws_access_key_id='$AWS_ACCESS_KEY_ID'
aws_secret_access_key='$AWS_SECRET_ACCESS_KEY'
EOF_AWS_CREDS'

    sudo bash -c 'chmod 777 '$AWS_SHARED_CREDENTIALS_FILE

    sudo bash -c 'cat > "/home/'$USER'/.aws/.'$ORG'/config" <<- EOF_AWS_CONFIG
[default]
output=json
color=auto
EOF_AWS_CONFIG'
    sudo bash -c 'chmod 777 "/home/'$USER'/.aws/.'$ORG'/config"'

    export AWS_PROFILE="$AWS_PROFILE"

  }

  export EXIT_CODE=0
}
