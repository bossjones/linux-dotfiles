if is-executable node -o ! is-executable curl -o ! is-executable git -o ! is-executable nvm; then
  echo "Skipped: Homebrew (missing: node, curl and/or git)"
  _node_result=$(is-executable node )
  _curl_result=$(is-executable curl )
  _git_result=$(is-executable git )
  _nvm_result=$(is-executable nvm )
  echo "node: ${_node_result}"
  echo "curl: ${_curl_result}"
  echo "git: ${_git_result}"
  echo "nvm: ${_nvm_result}"
  return
fi

if is_ubuntu; then
  # linux-only
  mkdir -p ~/dev/
  cd ~/dev
  git clone https://github.com/bats-core/bats-core
  cd bats-core
  ./install.sh /usr/local
fi
