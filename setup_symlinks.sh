#!/bin/bash
# Setup spaceship symlink
spaceship_theme_file="$ZSH_CUSTOM/themes/spaceship.zsh-theme"
if [ -e "$spaceship_theme_file" ]; then
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
else
  echo "Skipping Spaceship symlink for ZSH theme"
fi

echo "--------------------------------------------------------------------"
echo "Starting stow process..."

# Below is just setting up GNU Stow
# List all directories in dotfiles
directories=$(find . -maxdepth 1 -type d ! -name .)
ignored_directories=(".git")

# Loop through the list of directories
for dir in $directories; do
  # Check if dir is a valid directory
  if [ -d "$dir" ] && [[ ! " ${ignored_directories[@]} " =~ " $(basename "$dir") " ]]; then
    # Run the GNU Stow command `stow <directory_name>` to setup
    echo "Stowing $(basename "$dir")"
    stow "$(basename "$dir")"
  fi
done

echo "--------------------------------------------------------------------"
echo "Finished stowing process..."
