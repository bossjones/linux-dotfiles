SHELL = /bin/bash
DOTFILES_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

# SOURCE: https://github.com/wk8838299/bullcoin/blob/8182e2f19c1f93c9578a2b66de6a9cce0506d1a7/LMN/src/makefile.osx
HAVE_BREW=$(shell brew --prefix >/dev/null 2>&1; echo $$? )

.PHONY: test

PR_SHA                := $(shell git rev-parse HEAD)

define ASCILOGO
bossjones dotfiles
=======================================
endef

export ASCILOGO

# http://misc.flogisoft.com/bash/tip_colors_and_formatting

RED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

all: $(OS)

macos: sudo core-macos packages link

linux: core-linux link

core-macos: brew bash git npm ruby

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

packages: brew-packages cask-apps node-packages gems

link: stow-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then mv -v $(HOME)/$$FILE{,.backup}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.backup ]; then mv -v $(HOME)/$$FILE.backup $(HOME)/$${FILE%%.backup}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

bash: BASH=/usr/local/bin/bash
bash: SHELLS=/private/etc/shells
bash: brew
ifeq (${DETECTED_OS}, Darwin)
	if ! grep -q $(BASH) $(SHELLS); then brew install bash bash-completion@2 pcre && sudo append $(BASH) $(SHELLS) && chsh -s $(BASH); fi
endif

git: brew
	brew install git git-extras
npm:
ifeq (${DETECTED_OS}, Darwin)
	brew install nvm; . $(NVM_DIR)/nvm.sh; nvm install stable
else
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/creationix/nvm.git $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install stable
endif

ruby: brew
ifeq (${DETECTED_OS}, Darwin)
	brew install ruby
else
	echo "figure out generic way to install Ruby on $(DETECTED_OS)"
endif

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

node-packages: npm
	. $(NVM_DIR)/nvm.sh; npm install -g $(shell cat install/npmfile)

gems: ruby
ifeq (${DETECTED_OS}, Darwin)
	export PATH="/usr/local/opt/ruby/bin:$PATH"; gem install $(shell cat install/Gemfile)
else
	echo "figure out generic way to install Ruby gems on $(DETECTED_OS)"
endif

test:
	bats test/*.bats

sed-travis:
	bash ./sed-travis.sh

test: shellcheck

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

shellcheck:
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh

build-fedora-force:
	docker build \
	--rm \
	--force-rm \
	--pull \
	--no-cache \
	-t bossjones/dotfile-test-fedora27:latest \
	-f Dockerfile.fedora27 .

build-fedora:
	docker build \
	-t bossjones/dotfile-test-fedora27:latest \
	-f Dockerfile.fedora27 .

run-fedora-systemd:
	docker kill dotfile-test-fedora27
	docker rm dotfile-test-fedora27
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--security-opt seccomp=unconfined \
	--tmpfs /run \
	--tmpfs /run/lock \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v $(PWD):/etc/ansible/roles/role_under_test:ro \
	-d \
	--tty \
	--entrypoint "/usr/sbin/init" \
	--name dotfile-test-fedora27 \
	bossjones/dotfile-test-fedora27:latest true

	docker exec -i --tty \
	--privileged \
	-u developer \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash -c "git clone -b feature-font-username https://github.com/bossjones/linux-dotfiles ~developer/.dotfiles; cd ~developer/.dotfiles; source ~developer/.dotfiles/install.sh"

run-fedora-systemd-check-only:
	docker kill dotfile-test-fedora27
	docker rm dotfile-test-fedora27
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--security-opt seccomp=unconfined \
	--tmpfs /run \
	--tmpfs /run/lock \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v $(PWD):/etc/ansible/roles/role_under_test:ro \
	-d \
	--tty \
	--entrypoint "/usr/sbin/init" \
	--name dotfile-test-fedora27 \
	bossjones/dotfile-test-fedora27:latest true

	docker exec -i --tty \
	--privileged \
	-u developer \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash -c "export CHECK_ONLY=1; git clone -b feature-font-username https://github.com/bossjones/linux-dotfiles ~developer/.dotfiles; cd ~developer/.dotfiles; source ~developer/.dotfiles/install.sh"

ci-fedora: build-fedora run-fedora-systemd

ci-fedora-force: build-fedora-force run-fedora-systemd

ci-fedora-check-only: build-fedora run-fedora-systemd-check-only

docker-exec-ci-fedora:
	docker exec -i --tty \
	--privileged \
	-u developer \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash

docker-exec-ci-fedora-login:
	docker exec -i --tty \
	--privileged \
	-u developer \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash -l

upgrade_pip:
	@sudo pip install --upgrade pip

# https://github.com/pypa/pip/issues/3165#issuecomment-146666737
upgrade_ansible:
	@sudo -H pip install --upgrade ansible --ignore-installed six

bootstrap:
	@xcode-select --install
	@sudo xcodebuild -license
	@sudo easy_install pip
	@sudo pip install ansible

bootstrap-python:
	brew update
	# brew outdated pyenv || brew upgrade pyenv
	brew install python@2
	brew link --overwrite python@2
	brew install python@3
	brew link --overwrite python@3
	sudo easy_install pip
	sudo pip install --upgrade pip setuptools
	sudo pip install virtualenv
	# python -m virtualenv env
	# source env/bin/activate
	python --version
	which python

cp-config-travis:
	cp ./ansible/tests/config.yml ./ansible/config.yml

# converge:
# 	@$(ANSIBLE_COMMAND_LOCAL_WITH_VAULT) $(ANSIBLE_PLAYBOOKS_DIRECTORY)/main.yml

# encrypt:
# 	@$(VAULT_COMMAND) encrypt $(ANSIBLE_SENSITIVE_CONTENT_FILES)

# decrypt:
# 	@$(VAULT_COMMAND) decrypt $(ANSIBLE_SENSITIVE_CONTENT_FILES)

# encrypt_pre_commit: encrypt
# 	@git add $(ANSIBLE_SENSITIVE_CONTENT_FILES)

install:
	install -d . ~/.dotfiles
