#!/usr/bin/env bash

# homebrew
 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install fzf
brew install yarn
brew install stow
brew install autojump
brew install wget
brew install diff-so-fancy
brew install the_silver_searcher
brew install neovim
brew install fd
brew install git

brew cask install bettertouchtool
brew cask install iterm2
brew cask install karabiner-elements

# install fonts
curl -L https://github.com/hbin/top-programming-fonts/raw/master/install.sh | bash
sudo spctl --master-disable # disable security error when trying to install from unknown dev


# osx

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Finder: show hidden files by default
defaults write com.apple.Finder AppleShowAllFiles -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true


  # Disable press and hold character picker.
defaults write -g ApplePressAndHoldEnabled -bool false


defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# remove all default app icons from the Dock
defaults write com.apple.dock persistent-apps -array

#hide menu
defaults write NSGlobalDomain _HIHideMenuBar -bool true

