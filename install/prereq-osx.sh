#!/usr/bin/env bash

# SOURCE: https://github.com/xiaohanyu/oh-my-laptop/blob/master/bootstrap.sh

unamestr=$(uname)

# Mac OS X
if [[ $unamestr == "Darwin" ]]; then

    if [[ "${SKIP_DOTFILES_FORCE_INSTALL_HOMEBREW}x" == "x" ]]; then
    pip || easy_install pip
    brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask || brew tap caskroom/cask
    brew install ansible
    fi
# debian, ubuntu, mint etc.
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
    sudo apt-get update --yes
    sudo apt-get install --yes python-pip python-dev git ansible
fi
