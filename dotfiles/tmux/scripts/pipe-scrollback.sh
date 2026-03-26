#!/usr/bin/env bash

tmpfile=$(mktemp).tmp
editor="${EDITOR:-$HOME/.nix-profile/bin/nvim}"

tmux capture-pane -peS -32768 >$tmpfile
tmux display-popup -w 70% -h 70% "$editor '+luafile $HOME/.config/tmux/scripts/vi-mode.lua' '+ normal G $' $tmpfile"
