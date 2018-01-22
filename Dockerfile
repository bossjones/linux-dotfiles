FROM ubuntu:xenial
ENV TERM=xterm

RUN apt-get update \
    && apt-get install -y \
    git-core curl wget bash vim \
    sudo \
    && apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev -y \
    && rm -rf /var/lib/apt/lists/

RUN set -xe \
    && useradd -U -d /home/test -m -r -G adm,sudo,dip,plugdev,tty,audio test \
    && usermod -a -G test -s /bin/bash -u 1000 test \
    && groupmod -g 1000 test \
    && ( mkdir /home/test/.ssh \
    && chmod og-rwx /home/test/.ssh \
    && echo "${USER_SSH_PUBKEY}" \
    > /home/test/.ssh/authorized_keys \
    ) \
    && echo 'test     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '%test     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo 'test:test' | chpasswd

USER test
WORKDIR /home/test
RUN git clone https://github.com/bossjones/linux-dotfiles.git /home/test/.dotfiles; cd /home/test/.dotfiles/; git checkout feature-new-dotfiles-layout
