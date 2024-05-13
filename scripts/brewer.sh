#!/bin/bash

# Sync brews, cask and taps
# Update all brew packages

brew update

brew bundle install --cleanup --force --file="$HOME/dotfiles/packages.brew"

brew upgrade

echo "brew packages synced and up-to-date."
