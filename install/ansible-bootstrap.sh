if is-macos ; then
  # os x
  cd ~/
  sudo easy_install pip && \
  sudo pip install ansible && \
  echo '[defaults]'>> ansible.cfg; \
  echo 'roles_path = ../' >> ansible.cfg && \
  sudo mkdir -p /etc/ansible && \
  sudo touch /etc/ansible/hosts && \
  echo -e '[local]\nlocalhost ansible_connection=local' | sudo tee -a /etc/ansible/hosts >  /dev/null && \
  mkdir ~/dev; \
  cd ~/dev && \
  git clone https://github.com/geerlingguy/mac-dev-playbook && \
  cd mac-dev-playbook && \
  ansible-galaxy install -r requirements.yml && \
  ansible-playbook main.yml --syntax-check && \
  ansible-playbook main.yml
else
# REQs for ruby
#   $ sudo apt-get install python-software-properties
#   $ sudo apt-add-repository ppa:brightbox/ruby-ng
#   $ sudo apt-get update
#   $ sudo apt-get install ruby2.1 ruby-switch
#   $ sudo ruby-switch --set ruby2.1
  # linux
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get autoremove -y && \
  sudo apt-get update -yqq && \
  sudo apt-get install -yqq software-properties-common \
                     python-software-properties && \
  sudo apt-get install -yqq build-essential \
                     libssl-dev \
                     libreadline-dev \
                     wget curl \
                     openssh-server && \
  sudo apt-get install -yqq python-setuptools \
                     perl pkg-config \
                     python python-pip \
                     python-dev && \
  sudo pip install ansible && \
  echo '[defaults]'>> ansible.cfg; \
  echo 'roles_path = ../' >> ansible.cfg && \
  sudo mkdir -p /etc/ansible && \
  sudo touch /etc/ansible/hosts && \
  echo -e '[local]\nlocalhost ansible_connection=local' | sudo tee -a /etc/ansible/hosts >   /dev/null && \
  mkdir ~/dev; \
  cd ~/dev && \
  mkdir -p ~/ansible && \
  cat << EOF > ~/ansible/bootstrap.yml
  ---
  - hosts: all
    become: yes
    become_method: sudo
    vars:
      ulimit_config:
        - domain: '*'
          type: soft
          item: nofile
          value: 64000
        - domain: '*'
          type: hard
          item: nofile
          value: 64000
    roles:
      #   - role: ulimit
      #   - role: sysctl-performance
      - role: zzet.rbenv
        rbenv_extra_depends: /home/test/.dotfiles/ruby/default-gems
        rbenv_extra_depends:
        - libjemalloc1
        - libjemalloc-dev
        - ctags
        rbenv:
          env: user
          version: v1.1.1
          default_ruby: 2.4.2
          rubies:
          - version: 2.4.2
        rbenv_users:
        - "test"
        rbenv_repo: "https://github.com/rbenv/rbenv.git"
        rbenv_plugins:
          - { name: "rbenv-vars",         repo: "https://github.com/rbenv/rbenv-vars.git",         version: "master" }
          - { name: "ruby-build",         repo: "https://github.com/rbenv/ruby-build.git",         version: "master" }
          - { name: "rbenv-default-gems", repo: "https://github.com/rbenv/rbenv-default-gems.git", version: "master" }
          - { name: "rbenv-installer",    repo: "https://github.com/rbenv/rbenv-installer.git",    version: "master" }
          - { name: "rbenv-update",       repo: "https://github.com/rkh/rbenv-update.git",         version: "master" }
          - { name: "rbenv-whatis",       repo: "https://github.com/rkh/rbenv-whatis.git",         version: "master" }
          - { name: "rbenv-use",          repo: "https://github.com/rkh/rbenv-use.git",            version: "master" }
          - { name: "rbenv-ctags",        repo: "https://github.com/tpope/rbenv-ctags.git",        version: "master" }
          # gem install gem-ctags
          # gem ctags
          - { name: "rbenv-each",        repo: "https://github.com/rbenv/rbenv-each.git",        version: "master" }
          - { name: "rbenv-aliases",        repo: "https://github.com/tpope/rbenv-aliases.git",        version: "master" }

        rbenv_root: "{% if rbenv.env == 'system' %}/usr/local/rbenv{% else %}~/.rbenv{% endif %}"

EOF
  cat << EOF > ~/ansible/hosts
  localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python2
EOF

fi


