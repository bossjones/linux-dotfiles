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
  sudo mkdir -p /etc/ansible && \
  sudo touch /etc/ansible/hosts && \
  echo -e '[local]\nlocalhost ansible_connection=local' | sudo tee -a /etc/ansible/hosts >   /dev/null && \
  mkdir ~/dev; \
  cd ~/dev
fi


