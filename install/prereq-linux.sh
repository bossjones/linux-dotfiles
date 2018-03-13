#!/usr/bin/env bash

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
