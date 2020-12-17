#!/usr/bin/env bash

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# # System-wide .bashrc file for interactive bash(1) shells.
# if [ -z "$PS1" ]; then
#    return
# fi

# PS1='\h:\W \u\$ '
# # Make bash check its window size after a process completes
# shopt -s checkwinsize

# [ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"


export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"



brew install fzf || true
brew install jq || true
brew install moreutils || true
brew install pyenv || true
brew install pyenv-virtualenv || true
brew install pyenv-virtualenvwrapper || true

brew install rbenv || true
brew install the_silver_searcher || true
brew install tmux || true
brew install tree || true
brew install vim || true
brew install direnv || true
brew install zsh || true
brew install mas || true

brew install openssl || true
brew install readline || true
brew install sqlite3 || true
brew install xz || true
brew install zlib || true
brew install python || true

# Need to activate python3 first

export _USER=$(whoami)
export _GROUP=staff
export CHECK_ONLY=1
# export _GITHUB_CI=1
# export _TRAVIS_CI=0

mkdir -p /Users/${_USER}/.pyenv/{plugins,versions}

export WORKON_HOME=/Users/${_USER}/.pyenv/versions
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

git clone https://github.com/pyenv/pyenv-virtualenvwrapper /Users/${_USER}/.pyenv/plugins/pyenv-virtualenvwrapper || true
git clone https://github.com/pyenv/pyenv-pip-rehash /Users/${_USER}/.pyenv/plugins/pyenv-pip-rehash || true
git clone https://github.com/pyenv/pyenv-update /Users/${_USER}/.pyenv/plugins/pyenv-update || true
git clone https://github.com/pyenv/pyenv-pip-migrate /Users/${_USER}/.pyenv/plugins/pyenv-pip-migrate || true
git clone https://github.com/pyenv/pyenv-doctor.git /Users/${_USER}/.pyenv/plugins/pyenv-doctor || true
git clone https://github.com/massongit/pyenv-pip-update.git /Users/${_USER}/.pyenv/plugins/pyenv-pip-update || true
git clone https://github.com/pyenv/pyenv-which-ext.git /Users/${_USER}/.pyenv/plugins/pyenv-which-ext || true
git clone https://github.com/jawshooah/pyenv-default-packages.git /Users/${_USER}/.pyenv/plugins/pyenv-default-packages || true


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export WORKON_HOME=~/.pyenv/versions
export PROJECT_HOME=~/dev
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

# pyenv init - > ~/pyenv_temp
# pyenv virtualenv-init - > ~/pyenv_venv_init
# source ~/pyenv_temp
# source ~/pyenv_venv_init
# export PROJECT_HOME=~/dev

# NOTE: THIS IS COMMENTED OUT ON PURPOSE WHEN SETTING UP
#pyenv virtualenvwrapper_lazy


echo "Install poetry"

pip install poetry==1.0
python3 -m venv .venv
source .venv/bin/activate
pip install ansible | tee -a depslog
pip install mitogen | tee -a depslog

echo "Install dependencies"
date -u
mkdir build
date +%s > build/stamp
python -c 'import sys; print("\n".join(sys.path))' | grep site-packages | tee -a depslog

date -u
echo "----====Deps====----"

mv ansible.cfg-travis ansible.cfg
cat ansible.cfg

# Add a hosts file.
sudo mkdir -p /etc/ansible
sudo touch /etc/ansible/hosts
echo -e '[local]\nlocalhost ansible_connection=local' | sudo tee /usr/local/etc/ansible/hosts > /dev/null

# zsh -c 'echo "Completed installation of dependencies in $(printf "%0.2f" $(($[$(date +%s)-$(cat build/stamp)]/$((60.))))) minutes"'

echo "Run tests"
cp -a $(pwd) ~/.dotfiles
ls -lta ~/.dotfiles
cd ~/.dotfiles

# NOTE: we skip this when we install locally
make sed-local-macos
cat ~/.dotfiles/ansible/provision.sh
source ~/.dotfiles/install.sh
brew install bash || true
bash -l -c 'pyenv versions'


echo "Finish build"
date -u
# zsh -c 'echo "Build completed in $(printf "%0.2f" $(($[$(date +%s)-$(cat build/stamp)]/$((60.))))) minutes"'
cd ~/.dotfiles
make bin_install
cd ~/.dotfiles/test/fixtures
brew install ffmpeg || true
brew install gawk || true
brew install gsed || true
ffmpeg-all-batch -t "@reactionmemesTV"
