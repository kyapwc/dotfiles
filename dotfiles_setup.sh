#!/bin/bash

dotfiles=(".vimrc" ".zshrc" ".gitconfig" ".bash_profile" ".gitignore_global" "oh-my-zsh")
dir=$HOME/dotfiles

for dotfile in "${dotfiles[@]}";do
  ln -sf "${HOME}/${dotfile}" "${dir}"
done
