#!/bin/bash

# Yabai
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
yabai --start-service

# SKHD
skhd --start-service

# ASDF (node)
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf reshim nodejs

# zsh-syntax-highligting & zsh-autosuggestions

# oh-my-zsh (can disable, not using it at all anymore)
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Sketchybar
brew services start sketchybar

# Monaspace font
brew install font-monaspace

# Youtube Music
brew install th-ch/youtube-music/youtube-music

# Janky borders setup to plist
echo "Setting up Janky Borders..."
# unload janky_borders first
launchctl unload ~/Library/LaunchAgents/com.user.janky_borders.plist

cp $HOME/dotfiles/borders/.config/borders/janky_borders.plist ~/Library/LaunchAgents/com.user.janky_borders.plist

launchctl load ~/Library/LaunchAgents/com.user.janky_borders.plist

# if ps aux | grep -v grep | grep "janky_borders" > /dev/null; then
#   pkill "janky_borders"
#   echo "Janky borders killed."
# else
#   echo "Janky borders not spawned."
# fi
#
# ./janky_borders >/dev/null 2>/dev/null &


# Right now Arc browser can sync my tabs but not the extensions and so on
# below is just a note on the different extensions i have available to install later on manually
# Bypass Paywalls (https://github.com/iamadamdev/bypass-paywalls-chrome)
# Bitwarden Password Manager
# Mardown Here (for emails mostly)
# React Developer Tools
# Tag Assistant Companion
# uBlock Origin
# Vimium
# Wappalyzer
# Youtube Windowed Fullscreen (https://chromewebstore.google.com/detail/youtube-windowed-fullscre/gkkmiofalnjagdcjheckamobghglpdpm?hl=en)

# Lastly, it is just setting up raycast
open $HOME/dotfiles/raycast/.config/raycast/Raycast\ 2024-05-14\ 20.47.11.rayconfig
# above will spawn raycast and prompt for password on this config for import
