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
        rbenv:
          env: user
          version: v1.1.1
          default_ruby: 2.4.2
          rubies:
          - version: 2.4.2
        rbenv_users:
        - "{{ base_vars.USER }}"
        rbenv_repo: "https://github.com/rbenv/rbenv.git"
        rbenv_plugins:
          - { name: "rbenv-vars",         repo: "https://github.com/rbenv/rbenv-vars.git",         version: "v1.2.0" }
          - { name: "ruby-build",         repo: "https://github.com/rbenv/ruby-build.git",         version: "master" }
          - { name: "rbenv-default-gems", repo: "https://github.com/rbenv/rbenv-default-gems.git", version: "ead67889c91c53ad967f85f5a89d986fdb98f6fb" }
          - { name: "rbenv-installer",    repo: "https://github.com/rbenv/rbenv-installer.git",    version: "bc21e7055dcc8f5f9bc66ce0c78cc9ae0c28cd7a" }
          - { name: "rbenv-update",       repo: "https://github.com/rkh/rbenv-update.git",         version: "1961fa180280bb50b64cbbffe6a5df7cf70f5e50" }
          - { name: "rbenv-whatis",       repo: "https://github.com/rkh/rbenv-whatis.git",         version: "v1.0.0" }
          - { name: "rbenv-use",          repo: "https://github.com/rkh/rbenv-use.git",            version: "v1.0.0" }

        rbenv_root: "{% if rbenv.env == 'system' %}/usr/local/rbenv{% else %}~/.rbenv{% endif %}"

EOF
  cat << EOF > ~/ansible/hosts
  localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python2
EOF

fi


