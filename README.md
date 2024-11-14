# ilm-opa-local-dev-setup

## PREREQUISTES

### Directory Structure

You MUST have the following relative directory structure:

```bash
# this could be also ~/opt or any dir your OS usr has rwx
BASE_PATH=/opt;
ORG=ilm
APPLICATION=ilm-opa

find $BASE_PATH/$ORG/$APPLICATION -maxdepth 1|sort

# the APPLICTION_PATH
/opt/ilm/ilm-opa

# the configuration project for the ilm-opa application
/opt/ilm/ilm-opa/ilm-opa-cnf

# the infrastucture project
/opt/ilm/ilm-opa/ilm-opa-inf

# the utils project - where the local dev env utilities residue
/opt/ilm/ilm-opa/ilm-opa-utl

# the wpb ui project - the wpb ui src
/opt/ilm/ilm-opa/ilm-opa-wui

# the GLOBAL csi infra-core
/opt/ilm/ilm-opa/infra-core

# the GLOBAL template generator project
/opt/ilm/ilm-opa/tpl-gen
```

Of course your BASE_PATH COULD be ( but probably shouldn't ) also anything like /var, ~/opt , ~/var etc...
You MUST have docker and make natively, docker MUST be able to share as volume your `<<BASE_PATH>>/<<ORG>>/<<APPLICATION>>`.

### BINARIES

You must have `make`, `bash` and `docker` on your host.

### OS user permissions

Your host OS user MUST have full ownership of the `<<BASE_PATH>>` dir on your host - if it does not, or you are not sure, use the `~/opt` dir.

### UID & GID

If those are not set volume sharing between the host and the containers WILL NOT WORK. You have been warned. This is not an opinion, this IS how docker works by design.

```bash
# Export UID and GID and set them in the current shell session
export UID=$(id -u) ; export GID=$(id -g);

# Permanently set UID and GID in .bashrc or .bash_profile
# Append them if they are not yet set
grep -q 'export UID=$(id -u)' ~/.bashrc || echo 'export UID=$(id -u)' >> ~/.bashrc ;
grep -q 'export GID=$(id -g)' ~/.bashrc || echo 'export GID=$(id -g)' >> ~/.bashrc ;
grep -q 'export DOCKER_BUILDKIT=1' ~/.bashrc || echo 'export DOCKER_BUILDKIT=1' >> ~/.bashrc
source ~/.bashrc ; # apply changes immediately

```

### Docker daemon permissions for volumes

On mac and Windows in the UI ensure that the docker daemon does have full capability to map volumes under the `<<BASE_PATH>>`

### YOU MUST enable DockerBuildKit as well

https://docs.docker.com/build/buildkit/#getting-started

#### On Linux

```bash
  sudo cat /etc/docker/daemon.json
{ "features": { "buildkit": true } }
```

## USAGE & HELP

type `make` in the project's root dir:

```bash
make
```

## SETUP

```bash
# build all the docker images and kick-in containers
export GITHUB_TOKEN="<<your-personal-gitlab-token-here>>"
make do-setup-ilm-opa-all

```

If you cannot, something is wrong, inspect the docker compose logs

## BUILD

Build in this context means "syntax check, autoformat and build ( if applicable)"

### Build separately the api

To build the backend api do:

````bash

make do-prune-docker-system         # 00.01 stop & completely wipe out all the docker caches for ALL IMAGES !!!
make do-setup-ilm-opa-all        #  01.02 setup the whole ilm-opa dockerized setup



```bash

## CONFIGURATION GENERATION
```bash
#to-history

export STEP=012-static-sites; ORG=ilm APP=opa ENV=dev TPL_SRC=/opt/ilm/ilm-opa/ilm-opa-inf SRC=/opt/ilm/ilm-opa/ilm-opa-cnf/ TGT=/opt/ilm/ilm-opa/ilm-opa-cnf make do-generate-config-for-step

# dev
while read -r step ; do echo "export STEP=$step; ORG=ilm APP=opa ENV=dev TPL_SRC=/opt/ilm/ilm-opa/ilm-opa-inf SRC=/opt/ilm/ilm-opa/ilm-opa-cnf/ TGT=/opt/ilm/ilm-opa/ilm-opa-cnf make -C ../ilm-opa-utl do-generate-config-for-step"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)

# tst
while read -r step ; do echo "export STEP=$step; ORG=ilm APP=opa ENV=dev TPL_SRC=/opt/ilm/ilm-opa/ilm-opa-inf SRC=/opt/ilm/ilm-opa/ilm-opa-cnf/ TGT=/opt/ilm/ilm-opa/ilm-opa-cnf make -C ../ilm-opa-utl do-generate-config-for-step"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)

# prd
while read -r step ; do echo "export STEP=$step; ORG=ilm APP=opa ENV=dev TPL_SRC=/opt/ilm/ilm-opa/ilm-opa-inf SRC=/opt/ilm/ilm-opa/ilm-opa-cnf/ TGT=/opt/ilm/ilm-opa/ilm-opa-cnf make -C ../ilm-opa-utl do-generate-config-for-step"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)

```

### PROVISION

```bash

export STEP=121-bas-gcp-wpb-vm; ORG=ilm APP=opa ENV=dev make -C ../ilm-opa-utl do-provision
# dev
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=dev make -C ../ilm-opa-utl do-provision"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)
# tst
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=tst make -C ../ilm-opa-utl do-provision"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)
# prd
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=prd make -C ../ilm-opa-utl do-provision"; done < <(ls -1 ../ilm-opa-inf/src/terraform|grep -v modules|sort)

```

### DIVEST

```bash


# one example
export STEP=121-bas-gcp-wpb-vm; ORG=ilm APP=opa ENV=dev make -C ../ilm-opa-utl do-divest

# all example
# dev
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=dev make -C ../ilm-opa-utl do-divest"; done < <(ls -1 src/terraform|grep -v modules|sort)
# tst
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=tst make -C ../ilm-opa-utl do-divest"; done < <(ls -1 src/terraform|grep -v modules|sort)
# prd
while read -r step ; do echo "export STEP=$step ; ORG=ilm APP=opa ENV=prd make -C ../ilm-opa-utl do-divest"; done < <(ls -1 src/terraform|grep -v modules|sort)


```
# ilm-opa-inf
