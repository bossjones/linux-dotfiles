#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM="xterm-256color"

# history modifications etc
# source ~/.scarlett_aliases

source $HOME/.bashrc

# *************************************
# **********************************************
# Start SOURCE: geerlingguy
# **********************************************
# Use colors.
# export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad

# # Custom $PATH with extra locations.
# export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH

# # Syntax-highlight code for copying and pasting.
# # Requires highlight (`brew install highlight`).
# function pretty() {
#   pbpaste | highlight --syntax=$1 -O rtf | pbcopy
# }

# # Git upstream branch syncer.
# # Usage: gsync master (checks out master, pull upstream, push origin).
# function gsync() {
#   if [[ ! "$1" ]] ; then
#       echo "You must supply a branch."
#       return 0
#   fi

#   BRANCHES=$(git branch --list $1)
#   if [ ! "$BRANCHES" ] ; then
#      echo "Branch $1 does not exist."
#      return 0
#   fi

#   git checkout "$1" && \
#   git pull upstream "$1" && \
#   git push origin "$1"
# }

# # Super useful Docker container oneshots.
# # Usage: dockrun, or dockrun [centos7|fedora24|debian8|ubuntu1404|etc.]
# dockrun() {
#   docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
# }

# # Enter a running Docker container.
# function denter() {
#   if [[ ! "$1" ]] ; then
#       echo "You must supply a container ID or name."
#       return 0
#   fi

#   docker exec -it $1 bash
#   return 0
# }

# # Use rbenv.
# if [ -f /usr/local/bin/rbenv ]; then
#   eval "$(rbenv init -)"
# fi
# ********************************

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-plain'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@github.com'

# Set my editor and git editor
export EDITOR="vim"
export GIT_EDITOR='vim'

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Don't check mail when opening terminal.
unset MAILCHECK

# Tab complete sudo commands
complete -cf sudo

# Load Bash It
if [ -e $BASH_IT/bash_it.sh ]; then
  source $BASH_IT/bash_it.sh
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# load the last 5000 lines into memory
HISTSIZE=50000000
# save 10000 lines to disk
HISTFILESIZE=$HISTSIZE
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# have bash immediately add commands to our history instead of waiting for the end of each session
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
	-o "nospace" \
	-W "$(grep "^Host" ~/.ssh/config | \
	grep -v "[?*]" | cut -d " " -f2 | \
	tr ' ' '\n')" scp sftp ssh


export CHEATCOLORS=true
export LESSCHARSET=utf-8

# NOTE: Taken from oh-my-fedora

alias __git_find_subcommand='__git_find_on_cmdline'
alias g='git'
alias ga='git add'
alias gall='git add .'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gci='git commit --interactive'
alias gcl='git clone'
alias gcm='git commit -v -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gd='git diff | /usr/local/bin/mvim -f'
alias gdel='git branch -D'
# alias gdv='git diff -w "$@" | vim -R -'
alias get='git'
alias gexport='git archive --format zip --output'
alias gg='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias gl='git pull'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gm='git merge'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gp='git push'
alias gpo='git push origin'
alias gpp='git pull && git push'
alias gpr='git pull --rebase'
alias gs='git status'
alias gsl='git shortlog -sn'
alias gss='git status -s'
alias gst='git status'
alias gup='git fetch && git rebase'
alias gus='git reset HEAD'
alias gw='git whatchanged'

# export PATH="~/.bin:$PATH"

# source ~/.super_aliases

# if [ -f `which powerline-daemon` ]; then
#   powerline-daemon -q
#   POWERLINE_BASH_CONTINUATION=1
#   POWERLINE_BASH_SELECT=1
#   . /usr/share/powerline/bindings/bash/powerline.sh
# fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,aliases,functions,path,dockerfunc,extra,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file

# load custom aliases if they exist
for i in ~/bash.functions.d/*.sh; do
  test -x $i && . $i
done
unset i

################################################################
# NOTE: New stuff
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# # Fix vim colors inside tmux
# if [ -n $TMUX ]; then
#   alias vim="TERM=screen-256color vim"
# fi

# # Put bash in vim mode
# set -o vi

# # Set default editor to vim
# export EDITOR=vim

# dircolors
if [ -e ~/.dircolors ]; then
  eval `dircolors -b ~/.dircolors`
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		# shellcheck source=/dev/null
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		# shellcheck source=/dev/null
		. /etc/bash_completion
	fi
fi
for file in /etc/bash_completion.d/* ; do
	# shellcheck source=/dev/null
	source "$file"
done


##### # use a tty for gpg
##### # solves error: "gpg: signing failed: Inappropriate ioctl for device"
##### GPG_TTY=$(tty)
##### export GPG_TTY
##### # Start the gpg-agent if not already running
##### if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
##### 	gpg-connect-agent /bye >/dev/null 2>&1
##### 	gpg-connect-agent updatestartuptty /bye >/dev/null
##### fi
##### # Set SSH to use gpg-agent
##### unset SSH_AGENT_PID
##### if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
##### 	export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
##### fi
##### # add alias for ssh to update the tty
##### alias ssh="gpg-connect-agent updatestartuptty /bye >/dev/null; ssh"
