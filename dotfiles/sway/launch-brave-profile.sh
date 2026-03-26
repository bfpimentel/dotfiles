#!/usr/bin/env bash

set -euo pipefail

brave_bin="$HOME/.nix-profile/bin/brave"
swaymsg_bin="$HOME/.nix-profile/bin/swaymsg"

if [ ! -x "$brave_bin" ]; then
  brave_bin="$(command -v brave)"
fi

if [ ! -x "$swaymsg_bin" ]; then
  swaymsg_bin="$(command -v swaymsg)"
fi

case "${1:-}" in
  bruno)
    workspace="B"
    profile_dir="Default"
    ;;
  squibler)
    workspace="W"
    profile_dir="Profile 1"
    ;;
  *)
    exit 1
    ;;
esac

export CHROME_DESKTOP="com.brave.Browser.desktop"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-sway}"
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-sway}"
export DESKTOP_SESSION="${DESKTOP_SESSION:-sway}"
export NIXOS_OZONE_WL=1

"$swaymsg_bin" workspace "$workspace" >/dev/null
exec "$brave_bin" \
  --profile-directory="$profile_dir" \
  --new-window \
  --ignore-gpu-blocklist \
  --enable-gpu-rasterization \
  --enable-zero-copy
