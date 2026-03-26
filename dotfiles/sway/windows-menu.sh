#!/usr/bin/env bash

set -euo pipefail

swaymsg_bin="$HOME/.nix-profile/bin/swaymsg"
jq_bin="$HOME/.nix-profile/bin/jq"
wofi_bin="$HOME/.nix-profile/bin/wofi"

if [ ! -x "$swaymsg_bin" ]; then
  swaymsg_bin="$(command -v swaymsg)"
fi

if [ ! -x "$jq_bin" ]; then
  jq_bin="$(command -v jq)"
fi

if [ ! -x "$wofi_bin" ]; then
  wofi_bin="$(command -v wofi)"
fi

windows="$($swaymsg_bin -t get_tree | $jq_bin -r '
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

selection="$(printf '%s\n' "$windows" | "$wofi_bin" --dmenu --prompt "Windows" --insensitive)" || exit 0
[ -z "$selection" ] && exit 0

con_id="${selection%%$'\t'*}"
exec "$swaymsg_bin" "[con_id=$con_id] focus"
