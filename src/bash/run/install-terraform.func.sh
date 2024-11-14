#!/usr/bin/env bash
# attempt to install terraform, if it is missing!!! Obs needs sudo!!!
do_install_terraform() {
  export DEBIAN_FRONTEND=noninteractive
  # defined in the Makefile or the calling shell
  #ver="${TERRAFORM_VERSION:-}" # exported from Makefile

  # TODO: we are completely ignoring above expression, we should fetch from above
  declare -a TERRAFORM_VERSIONS=("1.0.1" "1.1.9" "1.2.2")

  for terraform_version in ${TERRAFORM_VERSIONS[@]}; do
    {

      echo "Installing terraform version $terraform_version ..."

      if [ "$(uname)" == "Darwin" ]; then
        os='darwin_amd64'
      elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        os='linux_amd64'
      fi

      download_file='/tmp/terraform_'"$terraform_version"'_'"$os"'.zip'

      wget -O "$download_file" "https://releases.hashicorp.com/terraform/$terraform_version/terraform_""$terraform_version"'_'$os'.zip'
      sudo unzip -o $download_file -d $HOME'/.terraform.versions/'
      sudo mv -v $HOME'/.terraform.versions/terraform' $HOME'/.terraform.versions/terraform_'"$terraform_version"
    }

    # only creates link for latest version, different versions should be handled by tfswitch
    sudo ln -sfn $HOME'/.terraform.versions/terraform_'"$terraform_version" '/usr/local/bin/terraform'

    which terraform 2>/dev/null || {
      echo >&2 "The terraform binary is missing ! Aborting ..."
      exit 1
    }

    which terraform && echo "terraform is deployed and runnable."

  done
  export EXIT_CODE=0
}
