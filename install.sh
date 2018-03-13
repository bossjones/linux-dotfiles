#!/usr/bin/env bash

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

e_header "Provision machine using ansible bootstrap.yml"
command-exists ansible && bash "$DOTFILES_DIR/ansible/provision.sh"

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

ln -sfv "$DOTFILES_DIR/runcom/.irbrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.rspec" ~
ln -sfv "$DOTFILES_DIR/runcom/.pryrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.pdbrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.pdbrc.py" ~
ln -sfv "$DOTFILES_DIR/runcom/.ptpython" ~
ln -sfv "$DOTFILES_DIR/runcom/.pythonrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.agignore" ~

e_header "Package managers & packages"

# Package managers & packages

. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/npm.sh"
. "$DOTFILES_DIR/install/bash.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"
. "$DOTFILES_DIR/install/gem.sh"

e_header "Run tests"

# Run tests

if is-executable bats; then bats test/*.bats; else echo "Skipped: tests (missing: bats)"; fi

e_header "Install extra stuff"

# Install extra stuff

if [ -d "$DOTFILES_EXTRA_DIR" -a -f "$DOTFILES_EXTRA_DIR/install.sh" ]; then
  . "$DOTFILES_EXTRA_DIR/install.sh"
fi
