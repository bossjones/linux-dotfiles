if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: rbenv (missing: brew and/or git)"
  return
fi

export DOTFILES_BREW_PREFIX_RBENV=`brew --prefix rbenv`
set-config "DOTFILES_BREW_PREFIX_RBENV" "$DOTFILES_BREW_PREFIX_RBENV" "$DOTFILES_CACHE"

# . "${DOTFILES_DIR}/system/.nvm"
# nvm install stable
# nvm alias default stable

# Globally install with npm

packages=(
  pry
  bundler
  ruby-debug-ide
  debase
  rcodetools
  rubocop
  fastri
  htmlbeautifier
  hirb
  gem-ctags
  travis
  excon
  pry-doc
  tmuxinator
)

eval "$(rbenv init -)"

if [ ! -d ~/.rbenv/versions/2.4.2 ]
then
  rbenv install 2.4.2

  rbenv shell 2.4.2

  gem install "${packages[@]}"
fi

