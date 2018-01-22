#!/usr/bin/env bash

cd ~/.dotfiles/ansible
ansible-galaxy install -r requirements.txt --roles-path roles/ -vvv
echo "localhost ansible_connection=local" > hosts.private
ansible-playbook main.yml --ask-pass --ask-become-pass
