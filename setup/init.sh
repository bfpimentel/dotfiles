#!/bin/bash

source "$(dirname "$0")/utils.sh"

print_banner
ask_sudo

configure_zdotdir() {
  if ! grep -q "ZDOTDIR=\$HOME/.config/zsh" "$HOME/.zshenv" 2>/dev/null; then
    echo 'ZDOTDIR=$HOME/.config/zsh' >>"$HOME/.zshenv"
  fi
}

execute "Configuring ZDOTDIR" configure_zdotdir

if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$(dirname "$0")/macos.sh"
  exit 0
fi

source "$(dirname "$0")/linux.sh"
exit 0
