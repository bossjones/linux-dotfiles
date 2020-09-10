if ! is-macos -o ! is-executable brew; then
  echo "Skipped: gem"
  return
fi

# brew install gpg2

# \curl -sSL https://get.rvm.io | bash -s stable

# FIXME: This needs to be installed via the correct packagemanager
# brew install ctags

# git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir -p $HOME/.rbenv/plugins
# git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
# git clone https://github.com/rbenv/rbenv-vars.git $HOME/.rbenv/plugins/rbenv-vars
# git clone https://github.com/rbenv/rbenv-each.git $HOME/.rbenv/plugins/rbenv-each
# git clone https://github.com/rkh/rbenv-update.git $HOME/.rbenv/plugins/rbenv-update
# git clone https://github.com/rkh/rbenv-whatis.git $HOME/.rbenv/plugins/rbenv-whatis
# git clone https://github.com/rkh/rbenv-use.git $HOME/.rbenv/plugins/rbenv-use
# git clone git://github.com/tpope/rbenv-aliases.git $HOME/.rbenv/plugins/rbenv-aliases
# git clone https://github.com/rbenv/rbenv-default-gems.git $HOME/.rbenv/plugins/rbenv-default-gems

cat << EOF > $HOME/.rbenv/default-gems
pry
bundler
ruby-debug-ide
debase
rcodetools
rubocop
fastri
htmlbeautifier
hirb
EOF

# gem-ctags

# git clone git://github.com/tpope/rbenv-ctags.git \
#   ~/.rbenv/plugins/rbenv-ctags
# rbenv ctags


# rbenv alias --auto

# rvm install 2.3
# rvm use 2.3 --default

# gem install lunchy
# gem install pygmentize

# list all available versions:
rbenv install -l

# install a Ruby version:
rbenv install 2.6.6

rbenv use 2.6.6
