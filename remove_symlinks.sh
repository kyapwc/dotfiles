echo "--------------------------------------------------------------------"
echo "Starting removal of symlinks process..."

# Below is just setting up GNU Stow
# List all directories in dotfiles
directories=$(find . -maxdepth 1 -type d ! -name .)
ignored_directories=(".git")

# Loop through the list of directories
for dir in $directories; do
  # Check if dir is a valid directory
  if [ -d "$dir" ] && [[ ! " ${ignored_directories[@]} " =~ " $(basename "$dir") " ]]; then
    # Run the GNU Stow command `stow <directory_name>` to setup
    echo "Un-Stowing $(basename "$dir")"
    stow -D "$(basename "$dir")"
  fi
done

echo "--------------------------------------------------------------------"
echo "Finished removal of symlinks process..."
