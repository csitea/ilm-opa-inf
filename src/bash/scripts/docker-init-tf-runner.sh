#!/bin/bash

set -x

test -z ${PROJ:-} && PROJ=tqa-crt-infra-app
test -z ${APPUSER:-} && APPUSER='appusr'

# /home/runner/work/${{ env.PROJ }}/${{ env.PROJ }}/opt/${{ env.ORG }}/${{ env.PROJ }}
# /home/appuser/home/runner/work/${{ env.PROJ }}/${{ env.PROJ }}/opt/${{ env.ORG }}/${{ env.PROJ }}
PROJ_PATH=$(echo $PROJ_PATH | perl -ne "s|/home/$APPUSR||g;print")
BASE_PATH=$(echo $BASE_PATH | perl -ne "s|/home/$APPUSR||g;print")

# test -d $venv_path && sudo rm -r $venv_path
# do not use this one ^^^^!!! Big GOTCHA !!!

cd ${PROJ_PATH} || exit 1

# spe-2880 - oherwise the CNF_VER git hash fetch will fail ...
git config --global --add safe.directory ${PROJ_PATH}


echo "cd ${PROJ_PATH}" >>~/.bashrc

trap : TERM INT
sleep infinity &
wait
