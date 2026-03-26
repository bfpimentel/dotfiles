#!/usr/bin/env bash

set -euo pipefail

if ! timeout 2 pactl info >/dev/null 2>&1; then
  systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service
fi

if command -v pwvucontrol >/dev/null 2>&1; then
  exec pwvucontrol
fi

exec pavucontrol
