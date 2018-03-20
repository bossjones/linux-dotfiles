#!/usr/bin/env bash

unamestr=$(uname)

if [[ $unamestr == "Darwin" ]]; then
    echo "OSX: Needs to be implemented"
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

