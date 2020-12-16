if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Bash 4"
  return
fi

# Warn that some commands will not be run if the script is not run as root.
if [[ $EUID -ne 0 ]]; then
  RUN_AS_ROOT=false
  printf "Certain commands will not be run without sudo privileges. To run as root, run the same command prepended with 'sudo', for example: $ sudo $0\n\n" | fold -s -w 80
else
  RUN_AS_ROOT=true
  # Update existing `sudo` timestamp until `.osx` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

brew install bash

if [[ "${_TRAVIS_CI}" == "1" ]]; then
    echo "TravisCI: skipping chsh -s /usr/local/bin/bash"
    return
elif [[ "${_GITHUB_CI}" == "1" ]]; then
  echo "TravisCI: skipping chsh -s /usr/local/bin/bash"
  return
fi

grep "/usr/local/bin/bash" /private/etc/shells &>/dev/null || sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells" && sudo chsh -s /usr/local/bin/bash
