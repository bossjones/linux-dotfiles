#!/usr/bin/env bash

git clone https://github.com/gpakosz/.tmux.git ~/dev/oh-my-tmux || true
ln -s -f ~/dev/oh-my-tmux/.tmux.conf ~/.tmux.conf || true
cp -vf ~/dev/oh-my-tmux/.tmux.conf.local ~/.tmux.conf.local