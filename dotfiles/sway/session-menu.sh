#!/usr/bin/env bash

set -euo pipefail

wofi_bin="$HOME/.nix-profile/bin/wofi"
swaymsg_bin="$HOME/.nix-profile/bin/swaymsg"

if [ ! -x "$wofi_bin" ]; then
  wofi_bin="$(command -v wofi)"
fi

if [ ! -x "$swaymsg_bin" ]; then
  swaymsg_bin="$(command -v swaymsg)"
fi

confirm_action() {
  local prompt="$1"
  local answer

  answer="$(
    printf '%s\n' \
      '󰄬 No' \
      '󰄭 Yes' \
      | "$wofi_bin" --dmenu --prompt "$prompt" --insensitive
  )" || return 1

  [ "$answer" = '󰄭 Yes' ]
}

selection="$(
  printf '%s\n' \
    '󰍃 Sign out' \
    '󰌾 Lock' \
    '󰜉 Reboot' \
    '󰐥 Shutdown' \
    | "$wofi_bin" --dmenu --prompt 'Session' --insensitive
)" || exit 0

[ -z "$selection" ] && exit 0

case "$selection" in
  '󰍃 Sign out')
    confirm_action 'Sign out?' && "$swaymsg_bin" exit
    ;;
  '󰌾 Lock')
    "$HOME/.config/sway/lock.sh"
    ;;
  '󰜉 Reboot')
    confirm_action 'Reboot?' && systemctl reboot
    ;;
  '󰐥 Shutdown')
    confirm_action 'Shutdown?' && systemctl poweroff
    ;;
esac
