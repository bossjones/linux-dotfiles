#!/usr/bin/env bash

pushd ~/.dotfiles/ansible
ansible-galaxy install -r requirements.yml --roles-path roles/ -vvv
echo "localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python2" > hosts.private
ansible-playbook bootstrap_xenial.yml
# ansible-playbook install_version_managers.yml --skip-tags="nvm"
ansible-playbook install_version_managers.yml
popd
