#!/usr/bin/env bash
do_provision_011_commit_remote_bucket_aws_accounts() {

  BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
  TIMESTAMP="$(date "+%y%m%d%H%M")"

  # Identify the commit author.
  git config --global user.email "ci-cd-usr-${TIMESTAMP}@users.noreply.github.com"
  git config --global user.name "ci-cd-usr-${TIMESTAMP}"

  # put all changes into the stash
  git stash

  # just in case if somebody pushed during our execution
  git reset --hard "origin/$BRANCH_NAME"

  # bring all the changes into the stash
  git stash pop

  # add them ALL
  git add .
  # Generate commit with the tf state changes.
  git commit -m "ci: automatic CI tfstate update ${TIMESTAMP}"
  git push origin "$BRANCH_NAME"
  rv=$?
  test $rv == "0" && export EXIT_CODE=0
}
