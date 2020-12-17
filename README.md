# linux-dotfiles
linux dotfiles setup ( currently tested with ubuntu, near future fedora, coreOS )


# Thanks
- https://github.com/jessfraz/dotfiles
- https://github.com/jessfraz/dockerfiles
- https://github.com/blacktop/dotfiles
- https://dotfiles.github.io/
- https://github.com/bndabbs/dotfiles
- https://github.com/webpro/dotfiles



# LOOK AT THIS ONE

- https://github.com/webpro/dotfiles


# Test in docker container

```
docker build --force-rm --no-cache -t dotfiles .

docker run -it dotfiles:latest bash
```


# Install?

```

1  cd ~/.dotfiles/
2  git pull
3  clear
4  git pull
5  clear
6  source ~/.dotfiles/install.sh
7  source ~/.nvm/nvm.sh
8  nvm ls
9  npm search bats
10  histor
11  history

```


# wip ~/.bashrc

```
source ~malcolm/.pyenv/.pyenvrc
source ~malcolm/.pyenv/completions/pyenv.bash

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
```



# .profile


```

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=~/dev
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

# # System-wide .profile for sh(1)
#
# if [ -x /usr/libexec/path_helper ]; then
# 	eval `/usr/libexec/path_helper -s`
# fi
#
# if [ "${BASH-no}" != "no" ]; then
# 	[ -r /etc/bashrc ] && . /etc/bashrc
# fi

```



# default ~/.bashrc


```
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
#
# # added by travis gem
# [ -f /Users/malcolm/.travis/travis.sh ] && source /Users/malcolm/.travis/travis.sh


# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

PS1='\h:\W \u\$ '
# Make bash check its window size after a process completes
shopt -s checkwinsize

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"


export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export WORKON_HOME=~/.pyenv/versions
export PROJECT_HOME=~/dev
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy


```


# Environment Variables

- `SKIP_DOTFILES_PROVISION=1`
- `SKIP_DOTFILES_PREREQ=1`: skip prereq-linux.sh
- `SKIP_DOTFILES_FORCE_INSTALL_HOMEBREW=1`: skip prereq-osx.sh
