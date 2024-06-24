#!/bin/bash

# ASDF settings
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
asdf reshim nodejs

asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
asdf install deno latest
asdf global deno latest

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Launching neovim in headless mode and syncing plugins (to ensure first neovim launch is fast)..."
# Install all nvim plugins so the first launch will be faster
nvim --headless "+Lazy! sync" +qa

# make hexokinase
if [ -d ~/.local/share/nvim/lazy/vim-hexokinase ]; then
  echo "Vim hexokinase detected... Running makefile"
  cd ~/.local/share/nvim/lazy/vim-hexokinase/
  make hexokinase
fi
echo "Aftermath is finished.."
