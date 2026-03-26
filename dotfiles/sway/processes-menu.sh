#!/usr/bin/env bash

set -euo pipefail

wofi_bin="$HOME/.nix-profile/bin/wofi"

if [ ! -x "$wofi_bin" ]; then
  wofi_bin="$(command -v wofi)"
fi

confirm_action() {
  local prompt="$1"
  local answer

  answer="$({
    printf '%s\n' '󰄬 No'
    printf '%s\n' '󰄭 Yes'
  } | "$wofi_bin" --dmenu --prompt "$prompt" --insensitive)" || return 1

  [ "$answer" = '󰄭 Yes' ]
}

processes="$({
  ps -u "$USER" -o pid=,comm= --sort=comm,pid | while read -r pid comm; do
    [ -n "$pid" ] || continue
    printf '%s\t%s\n' "$pid" "$comm"
  done
})"

[ -z "$processes" ] && exit 0

selection="$(printf '%s\n' "$processes" | "$wofi_bin" --dmenu --prompt 'Processes' --insensitive)" || exit 0
[ -z "$selection" ] && exit 0

pid="${selection%%$'\t'*}"
name="${selection#*$'\t'}"

action="$({
  printf '%s\n' '󰆴 Terminate'
  printf '%s\n' '󰗼 Details'
  printf '%s\n' '󰜺 Stop'
  printf '%s\n' '󰠳 Continue'
  printf '%s\n' '󰅖 Kill'
} | "$wofi_bin" --dmenu --prompt "Action: $name ($pid)" --insensitive)" || exit 0

[ -z "$action" ] && exit 0

case "$action" in
  '󰆴 Terminate')
    confirm_action "Terminate $name ($pid)?" && kill -TERM "$pid"
    ;;
  '󰗼 Details')
    details="$({
      ps -p "$pid" -o pid=,ppid=,state=,%cpu=,%mem=,etime=,comm=
    })"
    [ -n "$details" ] || exit 0
    printf '%s\n' "$details" | "$wofi_bin" --dmenu --prompt "Process $pid" --insensitive > /dev/null
    ;;
  '󰜺 Stop')
    confirm_action "Stop $name ($pid)?" && kill -STOP "$pid"
    ;;
  '󰠳 Continue')
    confirm_action "Continue $name ($pid)?" && kill -CONT "$pid"
    ;;
  '󰅖 Kill')
    confirm_action "Kill $name ($pid)?" && kill -KILL "$pid"
    ;;
esac
