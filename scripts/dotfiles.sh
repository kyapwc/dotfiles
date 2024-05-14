#!/bin/bash

# Remove all current configs before stow
CONFIG_DIR="$HOME/.config"

# Clean directories
rm -rf "$HOME/.vimrc"
rm -rf "$CONFIG_DIR/sketchybar"
rm -rf "$CONFIG_DIR/wezterm"
rm -rf "$CONFIG_DIR/nvim"
rm -rf "$CONFIG_DIR/alacritty"
rm -rf "$CONFIG_DIR/starship"
rm -rf "$CONFIG_DIR/spaceship"
rm -rf "$HOME/.zshrc"
rm -rf "$HOME/.oh-my-zsh"
rm -rf "$HOME/.fzf.zsh"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.gitignore_global"
rm -rf "$HOME/.tmux.conf"
rm -rf "$HOME/.yabairc"
rm -rf "$HOME/.skhdrc"

sh ./scripts/setup_symlinks.sh
echo "Removed symlinks & linked dotfiles."
