#!/usr/bin/env bash

cd ~/.dotfiles/ansible
ansible-galaxy install -r requirements.yml --roles-path roles/ -vvv
echo "localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python2" > hosts.private
ansible-playbook bootstrap_xenial.yml --ask-pass --ask-become-pass
