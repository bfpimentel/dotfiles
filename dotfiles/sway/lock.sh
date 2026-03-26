#!/usr/bin/env bash

set -euo pipefail

swaylock_bin="$HOME/.nix-profile/bin/swaylock"

if [ ! -x "$swaylock_bin" ]; then
    swaylock_bin="$(command -v swaylock)"
fi

exec "$swaylock_bin" \
    --daemonize \
    --screenshots \
    --effect-blur 7x5 \
    --clock \
    --timestr "%H:%M" \
    --datestr "%a %d %b" \
    --font "Victor Mono" \
    --font-size 30 \
    --indicator \
    --indicator-radius 95 \
    --indicator-thickness 6 \
    --line-color 00000000 \
    --separator-color 00000000 \
    --inside-color 00000088 \
    --ring-color ffffffcc \
    --text-color ffffffee \
    --key-hl-color ffffffff \
    --bs-hl-color 9a9a9aff
