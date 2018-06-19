#!/usr/bin/env bash
# SOURCE: https://github.com/myshov/dotfiles
# On a sparkling fresh installation of OS X:

# sudo softwareupdate -i -a
xcode-select --install
# Install the dotfiles with either Git or curl:

# Clone with Git
# git clone https://github.com/webpro/dotfiles.git
# source dotfiles/install.sh
# Remotely install using curl
# Alternatively, you can install this into ~/.dotfiles remotely without Git using curl:

# sh -c "`curl -fsSL https://raw.github.com/webpro/dotfiles/master/remote-install.sh`"
# Or, using wget:

# sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/webpro/dotfiles/master/remote-install.sh`"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

