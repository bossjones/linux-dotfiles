#!/usr/bin/env bash

set -x

[[ "$CHECK_ONLY" ]] && export CHECK_ONLY=--check

if [[ "${SKIP_DOTFILES_ANSIBLE_SKIP_LIST}x" == "x" ]]; then
  export SKIP_DOTFILES_ANSIBLE_SKIP_LIST="zsh,nvm"
fi

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
  _PATH_TO_PYTHON="/usr/bin/python"
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
  _PATH_TO_PYTHON="/usr/bin/python2"
fi


# Warn that some commands will not be run if the script is not run as root.
if [[ $EUID -ne 0 ]]; then
  RUN_AS_ROOT=false
  printf "Certain commands will not be run without sudo privileges. To run as root, run the same command prepended with 'sudo', for example: $ sudo $0\n\n" | fold -s -w 80
else
  RUN_AS_ROOT=true
  # Update existing `sudo` timestamp until `.osx` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi


# OVERRIDES: Use relative directory if travis
if [[ "${_TRAVIS_CI}" == "1" ]]; then
    _PATH_TO_PYTHON=`which python`
    pushd ~/build/bossjones/linux-dotfiles/ansible
else
    pushd ~/.dotfiles/ansible
fi

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
  # _GROUP=$(groups $(whoami) | cut -d' ' -f1)
  _GROUP=staff

  # If we set checkonly then run check, else run full suite
  if [[ "${CHECK_ONLY}" = "1" ]]; then
    ansible-playbook -vvvv install_version_managers_osx.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="${SKIP_DOTFILES_ANSIBLE_SKIP_LIST}" --check
  else
    ansible-playbook -vvvv install_version_managers_osx.yml \
    --extra-vars \
    "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="${SKIP_DOTFILES_ANSIBLE_SKIP_LIST}"
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
      "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="${SKIP_DOTFILES_ANSIBLE_SKIP_LIST}" --check
    else
      ansible-playbook -vvvv bootstrap_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}"

      ansible-playbook -vvvv install_version_managers_fedora.yml \
      --extra-vars \
      "bossjones__user=${_USER} bossjones__group=${_GROUP}" --skip-tags="${SKIP_DOTFILES_ANSIBLE_SKIP_LIST}"
    fi

fi
popd
