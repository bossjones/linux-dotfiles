#!/usr/bin/env bash

set -x

sed -i '.bak' 's,"bossjones__user=${_USER} bossjones__group=${_GROUP} configure_sudoers=false","bossjones__user=${_USER} bossjones__group=${_GROUP} configure_sudoers=true",g' ~/.dotfiles/ansible/provision.sh
