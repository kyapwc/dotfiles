#!/bin/bash
# Install the basic tools for env

if [[ $OSTYPE == 'linux-gnu' ]]; then
  # set keyboard map
  sudo -v

  sudo cp ./scripts/setkeyboardmap.sh /usr/lib/systemd/system-sleep/setkeyboardmap.sh
else
  # Homebrew
  command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew"; \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; }

  if [ -f /opt/homebrew/bin/brew ]; then
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/kenyap/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [ -f ~/.zprofile ]; then
    source ~/.zprofile
  fi

  brew analytics off
fi


## Have to setup git user and SSH keys

echo "Prelude done"
