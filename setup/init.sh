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

configure_ssh_config() {
  if [ ! -f "$HOME/.ssh/config" ]; then
    echo 'include $HOME/.config/ssh/config' >>"$HOME/.ssh/config"
  fi
}

execute "Configuring SSH Config" configure_ssh_config

if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$(dirname "$0")/macos.sh"
else
  source "$(dirname "$0")/linux.sh"
fi

exit 0
