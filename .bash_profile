#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM="xterm-256color"

# history modifications etc
# source ~/.scarlett_aliases

source $HOME/.bashrc

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

# Load Bash It
source $BASH_IT/bash_it.sh

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
alias gdv='git diff -w "$@" | vim -R -'
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
