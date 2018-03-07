#!/usr/bin/env bash
# SOURCE: https://github.com/porterjamesj/dotfiles/blob/master/bin/fix-venv.sh
#
# Fix virtualenv symlinks after upgrading python with Homebrew and then running
# `cleanup`.
#
# After upgrading Python using Homebrew and then running `brew cleanup` one can
# get this message while trying to run python:
# dyld: Library not loaded: @executable_path/../.Python
#   Referenced from: /Users/pablo/.venv/my-app/bin/python
#   Reason: image not found
# Trace/BPT trap: 5
#
# This happens because the symlinks in the virtualenv point to paths that no
# longer exist. This script is intended to fix that.

if [[ "$1" == "" ]]; then
  echo "usage:"
  echo -e "\t./$(basename "$0") <VIRUTALENV-DIR>"
  echo "example:"
  echo -e "\t./$(basename "$0") \$HOME/.virtualenvs"
  exit 0
fi

VENVS_DIR="$1"

# check if GNU find is installed
if [[ ! "$(type -P gfind)" ]]; then
    echo "gfind not installed"
    exit 1
fi

for entry in $(ls $VENVS_DIR | xargs -n 1 basename); do
  venv_name=$(basename "$entry")
  if [[ -d $VENVS_DIR/$venv_name ]]; then
    # check if Library symlink is broken
    if [[ "$(gfind $VENVS_DIR/$venv_name/.Python -type l -xtype l)" == "" ]]; then
      echo "== Virtualenv [$venv_name] is ok. Path: $VENVS_DIR/$venv_name"
    else
      echo "== Virtualenv [$venv_name] has broken symlinks. Path: $VENVS_DIR/$venv_name"
      echo -e "\tFixing [$venv_name]"
      echo -e "\tRemoving old symlinks..."
      echo -e "\tgfind $VENVS_DIR/$venv_name -type l -xtype l -delete"
      gfind $VENVS_DIR/$venv_name -type l -xtype l -delete
      python_symlink=$(readlink $VENVS_DIR/$venv_name/bin/python)
      python_version=$(echo $python_symlink | sed 's/python//g')
      echo -e "\tUpdating [$venv_name]..."
      if [[ $python_version == 3.* ]]; then
        echo -e "\tvirtualenv --python=$(which python3) $VENVS_DIR/$venv_name"
        virtualenv --python=$(which python3) $VENVS_DIR/$venv_name
      else
        echo -e "\tvirtualenv $VENVS_DIR/$venv_name"
        virtualenv $VENVS_DIR/$venv_name
      fi
    fi
  fi
done
