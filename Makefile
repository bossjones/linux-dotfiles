NON_ROOT_USER = developer

# SOURCE: https://github.com/mpereira/macbook-playbook
LOCAL_PROJECT_DIRECTORY         := $(shell pwd)
ANSIBLE_DIRECTORY               := .
ANSIBLE_PLAYBOOKS_DIRECTORY     := $(ANSIBLE_DIRECTORY)
ANSIBLE_ROLES_DIRECTORY         := $(ANSIBLE_DIRECTORY)/roles
ANSIBLE_INVENTORY               := $(ANSIBLE_DIRECTORY)/hosts
ANSIBLE_VERBOSE                 := -vv
ANSIBLE_VAULT_PASSWORD_FILE     := $(ANSIBLE_DIRECTORY)/.ansible_vault_password
ANSIBLE_SENSITIVE_CONTENT_FILES := \
  $(ANSIBLE_ROLES_DIRECTORY)/ssh-keys/files/id_rsa \
  $(ANSIBLE_ROLES_DIRECTORY)/s3cmd/files/.s3cfg \
  $(ANSIBLE_ROLES_DIRECTORY)/dotfiles/vars/environment.yml \
  $(ANSIBLE_ROLES_DIRECTORY)/prey/vars/api_key.yml

ANSIBLE_COMMAND := \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i $(ANSIBLE_INVENTORY) \
		--extra-vars "local_project_directory=$(LOCAL_PROJECT_DIRECTORY)"

ANSIBLE_COMMAND_LOCAL := \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i $(ANSIBLE_INVENTORY) \
		--extra-vars "local_project_directory=$(LOCAL_PROJECT_DIRECTORY)"

ANSIBLE_COMMAND_LOCAL_WITH_VAULT := \
	$(ANSIBLE_COMMAND_LOCAL) --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

VAULT_COMMAND := \
	ansible-vault --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE)

.PHONY: \
	all \
	bin \
	dotfiles \
	etc \
	test \
	shellcheck \
	upgrade_pip \
	upgrade_ansible \
	bootstrap \
	converge \
	encrypt \
	decrypt \
	encrypt_pre_commit \
	install \
	sed-travis

all: bin dotfiles etc

sed-travis:
	bash ./sed-travis.sh

bin:
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	gpg --list-keys || true;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;

etc:
	sudo mkdir -p /etc/docker/seccomp
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -f $$file $$f; \
	done
	systemctl --user daemon-reload || true
	sudo systemctl daemon-reload

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
	-u $(NON_ROOT_USER) \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash -c "git clone -b feature-font-username https://github.com/bossjones/linux-dotfiles ~$(NON_ROOT_USER)/.dotfiles; cd ~$(NON_ROOT_USER)/.dotfiles; source ~$(NON_ROOT_USER)/.dotfiles/install.sh"

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
	-u $(NON_ROOT_USER) \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash -c "export CHECK_ONLY=1; git clone -b feature-font-username https://github.com/bossjones/linux-dotfiles ~$(NON_ROOT_USER)/.dotfiles; cd ~$(NON_ROOT_USER)/.dotfiles; source ~$(NON_ROOT_USER)/.dotfiles/install.sh"

ci-fedora: build-fedora run-fedora-systemd

ci-fedora-force: build-fedora-force run-fedora-systemd

ci-fedora-check-only: build-fedora run-fedora-systemd-check-only

docker-exec-ci-fedora:
	docker exec -i --tty \
	--privileged \
	-u $(NON_ROOT_USER) \
	-w /etc/ansible/roles/role_under_test \
	dotfile-test-fedora27 env TERM=xterm bash

docker-exec-ci-fedora-login:
	docker exec -i --tty \
	--privileged \
	-u $(NON_ROOT_USER) \
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
# @$(ANSIBLE_COMMAND_LOCAL_WITH_VAULT) $(ANSIBLE_PLAYBOOKS_DIRECTORY)/bootstrap.yml
# @test -s $(ANSIBLE_VAULT_PASSWORD_FILE) \
# 	|| echo ATTENTION: Please create '$(PWD)/$(ANSIBLE_VAULT_PASSWORD_FILE)' with this project\'s Ansible Vault password

cp-config-travis:
	cp ansible/tests/config.yml ansible/config.yml

converge:
	@$(ANSIBLE_COMMAND_LOCAL_WITH_VAULT) $(ANSIBLE_PLAYBOOKS_DIRECTORY)/main.yml

encrypt:
	@$(VAULT_COMMAND) encrypt $(ANSIBLE_SENSITIVE_CONTENT_FILES)

decrypt:
	@$(VAULT_COMMAND) decrypt $(ANSIBLE_SENSITIVE_CONTENT_FILES)

encrypt_pre_commit: encrypt
	@git add $(ANSIBLE_SENSITIVE_CONTENT_FILES)

install:
	install -d . ~/.dotfiles
