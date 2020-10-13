#!/usr/bin/env bash

set -x

# https://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
profile_it_start () {
  PS4='+ $(date "+%s.%N")\011 '
  exec 3>&2 2>/tmp/bashstart.$$.log
  set -x
}

profile_it_stop () {
  set +x
  exec 2>&3 3>&-
}

# OVERRIDES: Use relative directory if travis
if [[ "${_TRAVIS_CI}x" == "x" ]]; then
  # NOTE: 6/3/2018 newly added
  # Ask for the administrator password upfront.
  sudo -v
fi

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
DOTFILES_EXTRA_DIR="$HOME/.extra"

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Soure utility functions
. "$DOTFILES_DIR/install/utilities.sh"

# Ubuntu-only stuff. Abort if not Ubuntu.
if is_ubuntu; then
  e_header "Ubuntu-only stuff. Abort if not Ubuntu."
  . "$DOTFILES_DIR/install/prereq-linux.sh"
fi

# Ubuntu-only stuff. Abort if not Ubuntu.
if is-macos; then
  e_header "EXPERIMENTAL ... this might break - Macos"
  . "$DOTFILES_DIR/install/prereq-linux.sh"
fi

# Put this in place before trying to install everything
cp -fv "$DOTFILES_DIR/system/.osx" ~/.osx
chmod +x ~/.osx

if [[ "${SKIP_DOTFILES_PROVISION}x" == "x" ]]; then
  e_header "Provision machine using ansible bootstrap.yml"
  command-exists ansible && bash "$DOTFILES_DIR/ansible/provision.sh"
fi

# Update dotfiles itself first
e_header "Update dotfiles itself first"

# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

e_header "Bunch of symlinks"

# Bunch of symlinks

ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.gemrc" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~

# Secondary round

mkdir -p ~/.ptpython
mkdir -p ~/.config/fontconfig/conf.d

ln -sfv "$DOTFILES_DIR/runcom/.irbrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.rspec" ~
ln -sfv "$DOTFILES_DIR/runcom/.pryrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.pdbrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.pdbrc.py" ~
ln -sfv "$DOTFILES_DIR/runcom/.ptpython_config.py" ~/.ptpython/config.py
ln -sfv "$DOTFILES_DIR/runcom/.pythonrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.agignore" ~
ln -sfv "$DOTFILES_DIR/runcom/.10-powerline-symbols.conf" ~/.config/fontconfig/conf.d/10-powerline-symbols.conf

# ln -sfv "$DOTFILES_DIR/runcom/.tm-theme" ~
# ln -sfv "$DOTFILES_DIR/runcom/.tmux.conf" ~
# ln -sfv "$DOTFILES_DIR/runcom/.tmux.conf.local" ~
ln -sfv "$DOTFILES_DIR/runcom/.tmuxinator" ~

e_header "Package managers & packages"

# Package managers & packages

# Pretty osx specific stuff
# DISABLING FOR NOW
. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/npm.sh"
. "$DOTFILES_DIR/install/bash.sh"
# . "$DOTFILES_DIR/install/brew-cask.sh"
# . "$DOTFILES_DIR/install/gem.sh"
. "$DOTFILES_DIR/install/rbenv.sh"

# Fonts
unamestr=$(uname)

e_header "Install fonts"

if [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
  mkdir -p ~/.local/share/fonts/
  cp -rv $DOTFILES_DIR/fonts/* ~/.local/share/fonts/
  fc-cache -v
fi

# e_header "Copy folders into .config"

# if [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
#   cp -rvf "$DOTFILES_DIR/runcom/.config/gtk-3.0" ~/.config/
#   cp -rvf "$DOTFILES_DIR/runcom/.config/powerline" ~/.config/
# fi

e_header "Run tests"

# Run tests

# e_header "Where is test folder"

# if is-executable bats; then bats "$DOTFILES_DIR"/test/*.bats; else echo "Skipped: tests (missing: bats)"; fi

e_header "Install extra stuff"

# Install extra stuff

# if [ -d "$DOTFILES_EXTRA_DIR" -a -f "$DOTFILES_EXTRA_DIR/install.sh" ]; then
#   . "$DOTFILES_EXTRA_DIR/install.sh"
# fi
