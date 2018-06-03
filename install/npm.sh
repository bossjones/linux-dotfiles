if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
  return
fi

brew reinstall nvm

export DOTFILES_BREW_PREFIX_NVM=`brew --prefix nvm`
set-config "DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_CACHE"

. "${DOTFILES_DIR}/system/.nvm"
nvm install stable
nvm alias default stable

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
)

npm install -g "${packages[@]}"
