#!/bin/bash

tmpfile=$(mktemp).tmp

tmux capture-pane -peS -32768 >$tmpfile
tmux display-popup -w 70% -h 70% "$EDITOR '+luafile $HOME/.config/tmux/scripts/vi-mode.lua' '+ normal G $' $tmpfile"
