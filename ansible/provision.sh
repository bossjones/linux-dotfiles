#!/usr/bin/env bash

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
  _PATH_TO_PYTHON="/usr/bin/python"
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
fi

pushd ~/.dotfiles/ansible
ansible-galaxy install -r requirements.yml --roles-path roles/ -vvv
echo "localhost ansible_connection=local ansible_python_interpreter=${_PATH_TO_PYTHON}" > hosts.private

cat hosts.private


# Mac OS X
if [[ $unamestr == "Darwin" ]]; then
  ansible-playbook bootstrap_osx.yml
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
    _USER=$(whoami)
    _GROUP=$(whoami)

    ansible-playbook -vvvv bootstrap_xenial.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}"
fi

# TODO: Add variable files for different machines
# ansible-playbook install_version_managers.yml --skip-tags="nvm"
if [[ $unamestr == "Darwin" ]]; then
  echo "OS X: Needs to be implemented"
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  ansible-playbook install_version_managers.yml
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
    echo "Fedora: Needs to be implemented"
    echo "Fedora: Try running ansible-playbook -vvvv install_version_managers_fedora.yml"

    _USER=$(whoami)
    _GROUP=$(whoami)

    ansible-playbook -vvvv bootstrap_fedora.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}"

    _USER=$(whoami)
    _GROUP=$(whoami)


    ansible-playbook -vvvv install_version_managers_fedora.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}"
fi
popd
