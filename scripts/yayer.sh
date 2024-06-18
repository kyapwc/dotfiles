#!/bin/bash

# Sync packages on arch
Red='\e[0;31m';
Gre='\e[0;32m';
Cya='\e[0;36m';
Whi='\e[0;37m';

# Synchronize package databases
echo -e "[${Red}*${Whi}] Updating system.."
yay -Syyu
echo -e "[${Gre}*${Whi}] Updating system done.."

packages=(
  "zsh-autosuggestions-git"
  "zsh-history-substring-search"
  "zsh-syntax-highlighting"
  "spaceship-prompt"
  "fzf"
  "vivid"
  "go"
  "vivid"
  "asdf-vm"
  "the_silver_searcher"
  "ripgrep"
  "wezterm"
  "slack-desktop"
  "fd"
  "tree"
  "jq"
  "nats-server"
  "protobuf"
  "redis"
  "git-delta-git"
  "aerc-git"
  "pass"
  "pandoc"
  "w3m"
  "viu"
  "moar"
  "wtfutil"
  "khard"
  "tmate"
  "lua"
  "neofetch"
  "neovim-git"
  "bat"
  "aws-cli-v2"
  "htop"
  "sddm-git"
  "deno"

  # Below is meant for sddm theme, later can setup in aftermath
  "qt6-5compat"
  "qt6-declaractive"
  "qt6-svg"
)

echo -e "[${Red}*${Whi}] Installing necessary packages.."
sudo yay --noconfirm -S "${packages[@]}" 2> /dev/null |\
awk '{if ($1 ~ /installing/) {print "installing: " $2} else if ($1 ~ /upgrading/) {print "upgrading: " $2}}'
echo -e "[${Gre}*${Whi}] Installing necessary packages done.."

echo -e "[${Red}*${Whi}] Changing \$SHELL to zsh.."
# Set zsh as main $SHELL
sudo chsh -s $(which zsh)
echo -e "[${Gre}*${Whi}] Changing \$SHELL to zsh done.."

echo -e "[${Red}*${Whi}] Installing sddm theme.."
# Check if sddm theme is already installed
# if it is, can skip this step
if ! [ -f /usr/share/sddm/themes/sddm-astronaut-theme ]; then
  sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
  sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
fi
if [ -f /etc/sddm.conf ] && [ -r /etc/sddm.conf ]; then
  if grep -q "sddm-astronaut-theme" /etc/sddm.conf; then
    echo "The file contains the line with 'sddm-astronaut-theme'.\

Skipping setting theme..."
  else
    echo "The file does not contain the line with 'sddm-astronaut-theme'."
    echo "[Theme]
    Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
  fi
fi
echo -e "[${Gre}*${Whi}] Installing sddm theme.."
