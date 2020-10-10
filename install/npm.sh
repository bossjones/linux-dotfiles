if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
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

brew reinstall nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

export DOTFILES_BREW_PREFIX_NVM=`brew --prefix nvm`
set-config "DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_CACHE"

. "${DOTFILES_DIR}/system/.nvm"

export _NPM_VERSION="v10.3.0"

if [ ! -d ~/.nvm/versions/${_NPM_VERSION} ]
then
  nvm install ${_NPM_VERSION}
  nvm alias default ${_NPM_VERSION}

  # Globally install with npm

  packages=(
    get-port-cli
    gtop
    historie
    nodemon
    npm
    release-it
    spot
    superstatic
    svgo
    tldr
    underscore-cli
    vtop
    whereami
    figlet-cli
    get-port-cli
    getmac
    speed-test
    spoof
    wireless-tools
    yaml-lint
    pathogen-pm
    diff-so-fancy
    docker-enter
    jsonlint
    pure-prompt
  )

  npm install -g "${packages[@]}"

fi


