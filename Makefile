NON_ROOT_USER = developer

.PHONY: all bin dotfiles etc test shellcheck

all: bin dotfiles etc


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
