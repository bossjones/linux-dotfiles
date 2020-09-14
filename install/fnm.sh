#!/usr/bin/env bash

brew install Schniz/tap/fnm || true

eval "$(fnm env --multi)"

export _NODE_VERSION_TO_INSTALL=10.3.0

if [ "$(fnm ls | grep -i ${_NODE_VERSION_TO_INSTALL} | wc -l)" = "0" ]; then
    fnm install ${_NODE_VERSION_TO_INSTALL}
    fnm use ${_NODE_VERSION_TO_INSTALL}
    fnm default ${_NODE_VERSION_TO_INSTALL}
    fnm current
    npm install -g vtop whereami figlet-cli get-port-cli getmac speed-test spoof wireless-tools yaml-lint pathogen-pm gtop npm diff-so-fancy docker-enter jsonlint pure-prompt
fi