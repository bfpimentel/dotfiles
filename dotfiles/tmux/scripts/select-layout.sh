#!/bin/bash

TMUXDIR="${TMUXDIR:-$HOME/.config/tmux}"

if [[ -z "$1" ]]; then
  SCRIPT_PATH=$(realpath "$0")
  tmux display-popup -E -h 30% -w 30% "ls '$TMUXDIR/layouts' | fzf --header='Select Layout' --reverse | xargs -I {} tmux run-shell \"$SCRIPT_PATH {}\""
  exit 0
fi

LAYOUT="$1"
PATH_TO_LAYOUT="$TMUXDIR/layouts/$LAYOUT"

if [[ -f "$PATH_TO_LAYOUT" ]]; then
  tmux select-layout "$(cat "$PATH_TO_LAYOUT")"
elif [[ -f "$LAYOUT" ]]; then
  tmux select-layout "$(cat "$LAYOUT")"
fi
