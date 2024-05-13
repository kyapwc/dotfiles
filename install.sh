#!/bin/bash

echo "Run entire installation step? (Y / N)"
read -r answer

if [[ $answer =~ ^[Yy]$ ]]; then
  echo "Start on installation..."

  sh ./scripts/prelude.sh
  sh ./scripts/system.sh
  sh ./scripts/brewer.sh
  sh ./scripts/dotfiles.sh
  sh ./scripts/aftermath.sh

  echo "Installations done"
else
  echo "Installation skipped"
fi
