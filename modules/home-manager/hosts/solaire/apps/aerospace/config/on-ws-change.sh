#!/bin/bash

set -e

current_monitor=$(aerospace list-monitors --focused | awk '{print $1}')
current_workspace=$(aerospace list-workspaces --focused)
win_list=$(aerospace list-windows --monitor "$current_monitor" | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}')

echo "$win_list" | while IFS= read -r number; do
  echo "Processing number: $number"
  aerospace move-node-to-workspace --window-id "$number" "$current_workspace" < /dev/null
  echo "continue"
done
