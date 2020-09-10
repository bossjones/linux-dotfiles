#!/usr/bin/env bash

unamestr=$(uname)

# Mac OS X
if [[ $unamestr == "Darwin" ]]; then
    sudo chown -R $(whoami):staff /usr/local/share/zsh/site-functions
    sudo chown -R $(whoami):staff /usr/local/share/zsh
fi