#!/usr/bin/env bash

code --list-extensions | xargs -L 1 echo code --install-extension
