#!/usr/bin/env bash

brew install Schniz/tap/fnm || true

eval "$(fnm env --multi)"

export _NODE_VERSION_TO_INSTALL=10.3.0

if [ "$(fnm ls | grep -i ${_NODE_VERSION_TO_INSTALL} | wc -l)" = "0" ]; then
    fnm install ${_NODE_VERSION_TO_INSTALL}
    fnm use ${_NODE_VERSION_TO_INSTALL}
    fnm default ${_NODE_VERSION_TO_INSTALL}
    fnm current
fi