#!/usr/bin/env bash

set -euo pipefail

windows="$(${HOME}/.nix-profile/bin/swaymsg -t get_tree | ${HOME}/.nix-profile/bin/jq -r '
  [
    recurse(.nodes[]?, .floating_nodes[]?)
    | select(.type? == "con")
    | select((.app_id? != null) or (.window_properties.class? != null))
    | select((.name // "") != "")
    | {
        id: .id,
        app: (.app_id // .window_properties.class // "unknown"),
        title: .name
      }
  ]
  | unique_by(.id)
  | sort_by(.app, .title)
  | .[]
  | "\(.id)\t\(.app) - \(.title)"
')"

[ -z "$windows" ] && exit 0

selection="$(printf '%s\n' "$windows" | ${HOME}/.nix-profile/bin/wofi --dmenu --prompt "Tasks" --insensitive)" || exit 0
[ -z "$selection" ] && exit 0

con_id="${selection%%$'\t'*}"

action="$(printf 'focus\nquit\n' | ${HOME}/.nix-profile/bin/wofi --dmenu --prompt "Action" --insensitive)" || action="focus"
[ -z "$action" ] && action="focus"

case "$action" in
    quit)
        ${HOME}/.nix-profile/bin/swaymsg "[con_id=${con_id}] kill" >/dev/null
        ;;
    *)
        ${HOME}/.nix-profile/bin/swaymsg "[con_id=${con_id}] focus" >/dev/null
        ;;
esac
