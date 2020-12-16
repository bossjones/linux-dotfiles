#!/usr/bin/env bash

# Mac
FILE="kubectl-fzf_darwin_amd64.tar.gz"
# Linux
FILE="kubectl-fzf_linux_amd64.tar.gz"

cd /tmp
wget "https://github.com/bonnefoa/kubectl-fzf/releases/latest/download/$FILE"
tar -xf $FILE
install cache_builder ~/bin/cache_builder

# kubectl_fzf.sh needs to be sourced after kubectl completion.

# bash version
wget https://raw.githubusercontent.com/bonnefoa/kubectl-fzf/master/kubectl_fzf.sh -O ~/.kubectl_fzf.sh

# zsh version
wget https://raw.githubusercontent.com/bonnefoa/kubectl-fzf/master/kubectl_fzf.plugin.zsh -O ~/.kubectl_fzf.plugin.zsh
