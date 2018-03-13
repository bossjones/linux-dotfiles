#!/usr/bin/env bash

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
  _PATH_TO_PYTHON="/usr/bin/python"
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
fi

pushd ~/.dotfiles/ansible
ansible-galaxy install -r requirements.yml --roles-path roles/ -vvv
echo "localhost ansible_connection=local ansible_python_interpreter=${_PATH_TO_PYTHON}" > hosts.private


# Mac OS X
if [[ $unamestr == "Darwin" ]]; then
  ansible-playbook bootstrap_osx.yml
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  ansible-playbook bootstrap_xenial.yml
fi

# TODO: Add variable files for different machines
# ansible-playbook install_version_managers.yml --skip-tags="nvm"
ansible-playbook install_version_managers.yml
popd
