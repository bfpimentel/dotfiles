#!/usr/bin/env bash

set -euo pipefail

wofi_bin="$HOME/.nix-profile/bin/wofi"

if [ ! -x "$wofi_bin" ]; then
  wofi_bin="$(command -v wofi)"
fi

selection="$(
  printf '%s\n' \
    '󰀻 Applications' \
    '󰖲 Tasks' \
    '󰍹 Processes' \
    '󰐥 Session' \
    | "$wofi_bin" --dmenu --prompt 'Menu' --insensitive
)" || exit 0

[ -z "$selection" ] && exit 0

case "$selection" in
  '󰀻 Applications')
    exec "$wofi_bin" --show drun
    ;;
  '󰖲 Tasks')
    exec "$HOME/.config/sway/task-manager.sh"
    ;;
  '󰍹 Processes')
    exec "$HOME/.config/sway/processes-menu.sh"
    ;;
  '󰐥 Session')
    exec "$HOME/.config/sway/session-menu.sh"
    ;;
esac
