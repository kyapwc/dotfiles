#!/bin/bash

echo "Run entire installation step? (Y / N)"
read -r answer

if [[ $answer =~ ^[Yy]$ ]]; then
  sh ./scripts/prelude.sh

  if [[ $OSTYPE == 'linux-gnu' ]]; then
    # Time to do linux stuff
    sh ./scripts/yayer.sh
    sh ./scripts/dotfiles.sh
  else
    echo "Start on installation..."

    sh ./scripts/system.sh
    sh ./scripts/brewer.sh
    sh ./scripts/dotfiles.sh
    sh ./scripts/aftermath.sh
  fi

  echo "Installations done"
else
  echo "Installation skipped"
fi
