#!/usr/bin/env bash

TMUXDIR="$HOME/.config/tmux"
LAYOUTDIR="$TMUXDIR/layouts"

for layout in "$LAYOUTDIR"/*; do
    [[ -x "$layout" && -f "$layout" ]] || continue

    name=$("$layout" --name 2>/dev/null)
    [[ -n "$name" ]] || name=$(basename "$layout")

    printf "%s\n" "$name"
done
