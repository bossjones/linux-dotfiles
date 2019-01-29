# This file is sourced by login shells only

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

if [[ "${RUN_DOTFILES_PROFILER}x" != "x" ]]; then
  profile_it_start
fi

# PS4='+ $(date "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

# INFO: BASH_SOURCE - An array variable whose members are the source filenames where the corresponding shell function names in the FUNCNAME array variable are defined. The shell function ${FUNCNAME[$i]} is defined in the file ${BASH_SOURCE[$i]} and called from ${BASH_SOURCE[$i+1]}

unamestr=$(uname)

# TODO: 5/8/2018 re-enable this, but dump error output to stderr or /dev/null
# READLINK=$(which greadlink || which readlink)
# READLINK=$(which readlink)
if [[ $unamestr == "Darwin" ]]; then
  READLINK=$(which greadlink || which readlink)
elif [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
  READLINK=$(which readlink)
elif [[ $unamestr == "Linux"  && -f $(which dnf) ]]; then
  READLINK=$(which readlink)
fi


CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Read cache

DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
[ -f "$DOTFILES_CACHE" ] && . "$DOTFILES_CACHE"

# Add dotfiles dir to cache
export DOTFILES_PATH_TO_DIR="${DOTFILES_DIR}"
set-config "DOTFILES_PATH_TO_DIR" "$DOTFILES_PATH_TO_DIR" "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters)

# rdebugrc
# SOURCE: https://github.com/skwp/dotfiles/tree/master/ruby

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,path,env,alias,alias.kube,completion,grep,prompt_bash_it,nvm,rbenv,rdebugrc,pyenv,cheatrc,powerline,custom,cargo,ccache,jenv,brew_env,golang,locales,terminal,fzf,vmware_env,tmux_env,less_env,git_wrapper}; do
  # The -f condition is true if the file ‘regularfile’ exists and is a regular file. A regular file means that it’s not a block or character device, or a directory. This way, you can make sure a usable file exists before doing something with it. You can even check if a file is readable!
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,php}.macos; do
    # The -f condition is true if the file ‘regularfile’ exists and is a regular file. A regular file means that it’s not a block or character device, or a directory. This way, you can make sure a usable file exists before doing something with it. You can even check if a file is readable!
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS
# PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
  for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
    [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
  done
fi

# osx

if [ -d "/usr/local/etc/bash_completion.d/" ]; then

  for i in $(ls /usr/local/etc/bash_completion.d/ | xargs -n 1 basename); do
    source /usr/local/etc/bash_completion.d/$i
  done
fi

# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR DOTFILES_EXTRA_DIR

if [[ "${RUN_DOTFILES_PROFILER}x" != "x" ]]; then
  profile_it_stop
fi

# set +x
# exec 2>&3 3>&-
