if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: rbenv (missing: brew and/or git)"
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

