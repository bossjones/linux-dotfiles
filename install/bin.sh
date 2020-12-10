#!/usr/bin/env bash

mkdir -p ~/bin || true
chmod +x $(PWD)/bin/fzf*
chmod +x $(PWD)/bin/ffmpeg*
chmod +x $(PWD)/bin/image*
chmod +x $(PWD)/bin/python*
chmod +x $(PWD)/bin/aspectcrop
chmod +x $(PWD)/bin/smartcrop
chmod +x $(PWD)/bin/aspectpad
chmod +x $(PWD)/bin/autocaption
chmod +x $(PWD)/bin/autotrim
chmod +x $(PWD)/bin/smartcrop
chmod +x $(PWD)/bin/open-browser-generic
chmod +x $(PWD)/bin/exponential_backoff


ln -sfv $(PWD)/bin/fzf* ~/bin/
ln -sfv $(PWD)/bin/python* ~/bin/
ln -sfv $(PWD)/bin/ffmpeg* ~/bin/
ln -sfv $(PWD)/bin/image* ~/bin/
ln -sfv $(PWD)/bin/aspectcrop ~/bin/
ln -sfv $(PWD)/bin/smartcrop ~/bin/
ln -sfv $(PWD)/bin/aspectpad ~/bin/
ln -sfv $(PWD)/bin/autocaption ~/bin/
ln -sfv $(PWD)/bin/autotrim ~/bin/
ln -sfv $(PWD)/bin/smartcrop ~/bin/
ln -sfv $(PWD)/bin/open-browser-generic ~/bin/
ln -sfv $(PWD)/bin/exponential_backoff ~/bin/
