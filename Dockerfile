FROM ubuntu:xenial
ENV TERM=xterm

# make apt use ipv4 instead of ipv6 ( faster resolution )
RUN sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf

################################################################################################################
# SOURCE: https://github.com/skwp/dotfiles/blob/master/Dockerfile
# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
    apt-get update && \
    apt-get install -yqq \
    locales \
    lsb-release \
    software-properties-common && \
    apt-get clean

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=$LANG

# Install dependencies
# `universe` is needed for ruby
# `security` is needed for fontconfig and fc-cache
RUN \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe security" && \
    add-apt-repository ppa:aacebedo/fasd && \
    apt-get update && \
    apt-get -yqq install \
    autoconf \
    build-essential \
    curl \
    fasd \
    fontconfig \
    git \
    python \
    python-setuptools \
    python-dev \
    ruby-full \
    sudo \
    tmux \
    vim \
    wget \
    zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
################################################################################################################

# SOURCE: https://github.com/rastasheep/ubuntu-sshd/blob/master/16.04/Dockerfile
RUN apt-get update \
    && apt-get install -y \
    git-core curl wget bash vim \
    sudo \
    && apt-get install language-pack-en-base procps file make patch autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev -y \
    && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    rm -rf /var/lib/apt/lists/

RUN set -xe \
    && useradd -U -d /home/test -m -r -G adm,sudo,dip,plugdev,tty,audio test \
    && usermod -a -G test -s /bin/bash -u 1000 test \
    && groupmod -g 1000 test \
    && ( mkdir /home/test/.ssh \
    && chmod og-rwx /home/test/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/test/.ssh/authorized_keys \
    ) \
    && echo 'test     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '%test     ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo 'test:test' | chpasswd

EXPOSE 22

ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# # Thanks to http://docs.docker.io/en/latest/examples/running_ssh_service/
# RUN mkdir /var/run/sshd

# # Update things and make sure the required packges are installed
# RUN apt-get update && \
#     apt-get install openssh-server sudo curl nfs-common -y && \
#     apt-get upgrade -y && \
#     apt-get clean

USER test
WORKDIR /home/test
RUN git clone https://github.com/bossjones/linux-dotfiles.git /home/test/.dotfiles; cd /home/test/.dotfiles/; git checkout feature-new-dotfiles-layout
