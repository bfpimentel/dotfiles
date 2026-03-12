#!/bin/bash

DIRECTION=$1

PANE_CACHE_DIR="/tmp/tmux_ssh_cache"
mkdir -p "$PANE_CACHE_DIR"

PANE_PID=$(tmux display-message -p "#{pane_pid}")

PANE_CACHE_FILE="$PANE_CACHE_DIR/tmux_ssh_$PANE_PID"

if [[ -f "$PANE_CACHE_FILE" ]]; then
  REMOTE_HOST=$(cat "$PANE_CACHE_FILE")
else
  SSH_COMMAND=$(ps -ao ppid,command | grep "^ *$PANE_PID " | grep " ssh " | head -n 1 | sed "s/^ *$PANE_PID //")
  if [[ -n "$SSH_COMMAND" ]]; then
    REMOTE_HOST=$(echo "$SSH_COMMAND" | awk '{print $NF}')
  fi
fi

if [[ -n "$REMOTE_HOST" ]]; then
  NEW_PANE_INFO=$(tmux split-window $DIRECTION -P -F "#{pane_pid}" "ssh $REMOTE_HOST")
  NEW_PANE_PID=$(echo "$NEW_PANE_INFO" | tr -d ' ')

  echo "$REMOTE_HOST" > "$PANE_CACHE_DIR/tmux_ssh_$NEW_PANE_PID"
else
  tmux split-window $DIRECTION -c "#{pane_current_path}"
fi

find "$PANE_CACHE_DIR" -name "tmux_ssh_*" -mtime +1 -delete 24>/dev/null
