if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Bash 4"
  return
fi

brew install bash

if [[ "${_TRAVIS_CI}" == "1" ]]; then
    echo "TravisCI: skipping chsh -s /usr/local/bin/bash"
    return
fi

grep "/usr/local/bin/bash" /private/etc/shells &>/dev/null || sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
sudo chsh -s /usr/local/bin/bash
