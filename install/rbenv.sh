if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
  return
fi



export DOTFILES_BREW_PREFIX_NVM=`brew --prefix rbenv`
set-config "DOTFILES_BREW_PREFIX_RBENV" "$DOTFILES_BREW_PREFIX_RBENV" "$DOTFILES_CACHE"

. "${DOTFILES_DIR}/system/.nvm"
nvm install stable
nvm alias default stable

# Globally install with npm

packages=(
  pry
  bundler
  ruby-debug-ide-0.6.0
  debase-0.2.2.beta10
  rcodetools
  rubocop
  fastri
  htmlbeautifier
  hirb
  gem-ctags
  travis
  excon
  pry-doc
)

rbenv install 2.4.2

rbenv shell 2.4.2

gem install "${packages[@]}"
