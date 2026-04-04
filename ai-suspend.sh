#!/bin/bash

ROOT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")
cd "${ROOT_DIR}"

## normal start
#vagrant up
#vagrant ssh

## update / rerun provisioning scripts
# vagrant up --provision
# vagrant ssh

## suspend it
# exit
vagrant suspend

