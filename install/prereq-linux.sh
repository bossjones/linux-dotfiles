#!/usr/bin/env bash

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
   cd ~/
   if [[ "${SKIP_DOTFILES_PREREQ}x" == "x" ]]; then
    sudo easy_install pip
    sudo pip install ansible
    echo '[defaults]'>> ansible.cfg; \
    echo 'roles_path = ../' >> ansible.cfg
    sudo mkdir -p /etc/ansible
    sudo touch /etc/ansible/hosts
    echo -e '[local]\nlocalhost ansible_connection=local' | sudo tee -a /etc/ansible/hosts > /dev/null
    sudo chown -R $(id -u):$(id -g) /etc/ansible/
    mkdir ~/dev; \
   fi
   cd ~/dev
# debian, ubuntu, mint etc.
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
    sudo apt-get update -yqq && \
    sudo apt-get install -yqq software-properties-common \
                        python-software-properties && \
    sudo apt-get install -yqq build-essential \
                        libssl-dev \
                        libreadline-dev \
                        wget curl \
                        openssh-server && \
    sudo apt-get install -yqq python-setuptools \
                        perl pkg-config \
                        python python-pip \
                        python-dev && \
    sudo easy_install pip && \
    sudo pip install ansible
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
    echo "Fedora: Needs to be implemented"
fi

