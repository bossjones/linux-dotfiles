if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts

# Install packages

# apps=(
#   alfred
#   dash2
#   dropbox
#   firefox
#   flux
#   font-fira-code
#   glimmerblocker
#   google-chrome
#   google-chrome-canary
#   hammerspoon
#   kaleidoscope
#   macdown
#   opera
#   screenflow
#   slack
#   sourcetree
#   spotify
#   sublime-text
#   transmit
#   virtualbox
#   visual-studio-code
#   vlc
# )

# brew cask install "${apps[@]}"

# # Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
# brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo

# # Link Hammerspoon config
# if [ ! -d ~/.hammerspoon ]; then ln -sfv "$DOTFILES_DIR/etc/hammerspoon/" ~/.hammerspoon; fi

# powerline fonts.
# SOURCE: https://github.com/wilmoore/dotfiles/blob/b00fb436c5eed7fa2969a41fc2f012f5060403f8/active/.config/software/brew-cask-install
brew cask install font-anonymous-pro-for-powerline
brew cask install font-dejavu-sans-mono-for-powerline
brew cask install font-droid-sans-mono-for-powerline
brew cask install font-fira-mono-for-powerline
brew cask install font-hack
brew cask install font-liberation-mono-for-powerline
brew cask install font-meslo-lg-for-powerline
brew cask install font-open-iconic
brew cask install font-open-sans
brew cask install font-sauce-code-powerline
