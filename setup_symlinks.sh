#!/bin/bash
start_time=$(date +%s)

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

# Loop through the list of directories
for dir in $directories; do
  # Check if dir is a valid directory
  if [ -d "$dir" ]; then
    # Run the GNU Stow command `stow <directory_name>` to setup
    echo "Stowing $(basename "$dir")"
    stow "$(basename "$dir")"
  fi
done

end_time=$(date +%s)
duration=$((end_time - start_time))

echo "--------------------------------------------------------------------"
echo "Finished stowing process in $duration seconds"