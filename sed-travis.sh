#!/usr/bin/env bash

set -x

sed -i '.bak' 's,"bossjones__user=${_USER} bossjones__group=${_GROUP}","bossjones__user=${_USER} bossjones__group=${_GROUP} configure_sudoers=false",g' ~/.dotfiles/ansible/provision.sh
