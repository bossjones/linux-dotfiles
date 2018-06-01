#!/usr/bin/env bash

[[ "$CHECK_ONLY" ]] && export CHECK_ONLY=--check

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
  _PATH_TO_PYTHON="/usr/bin/python"
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
fi

pushd ~/.dotfiles/ansible
ansible-galaxy install --force -r requirements.yml --roles-path roles/ -vvv
echo "localhost ansible_connection=local ansible_python_interpreter=${_PATH_TO_PYTHON}" > hosts.private

cat hosts.private


# Mac OS X
if [[ $unamestr == "Darwin" ]]; then
  echo "already bootstraped, run version manage now"
  # ansible-playbook bootstrap_osx.yml
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
  _USER=$(whoami)
  _GROUP=$(whoami)

  # If we set checkonly then run check, else run full suite
  if [[ "${CHECK_ONLY}" = "1" ]]; then
    ansible-playbook -vvvv install_version_managers_osx.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="zsh" --check
  else
    ansible-playbook -vvvv install_version_managers_osx.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="zsh"
  fi
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  ansible-playbook install_version_managers.yml
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
    _USER=$(whoami)
    _GROUP=$(whoami)

    # If we set checkonly then run check, else run full suite
    if [[ "${CHECK_ONLY}" = "1" ]]; then
      ansible-playbook -vvvv bootstrap_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}" --check

      ansible-playbook -vvvv install_version_managers_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="zsh,rbenv,nvm" --check
    else
      ansible-playbook -vvvv bootstrap_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}"

      ansible-playbook -vvvv install_version_managers_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="zsh,rbenv,nvm"
    fi

fi
popd
