#!/usr/bin/env sh

ws=${1:-$AEROSPACE_FOCUSED_WORKSPACE}

IFS=$'\n' all_wins=$(aerospace list-windows --all --format '%{window-id}|%{app-name}|%{window-title}|%{monitor-id}|%{workspace}')
IFS=$'\n' all_ws=$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-id}')

# Array of possible window titles
floating_titles=("Picture-in-Picture")

# Function to find matching PIP windows
find_windows_to_float() {
  local titles=("$@")
  local result=""
  for title in "${titles[@]}"; do
    local matches=$(printf '%s\n' "$all_wins" | rg "$title")
    result="$result"$'\n'"$matches"
  done
  echo "$result" | sed '/^\s*$/d' # Remove empty lines
}

pip_wins=$(find_windows_to_float "${floating_titles[@]}")
target_mon=$(printf '%s\n' "$all_ws" | rg "^$ws" | cut -d'|' -f2 | xargs)

move_win() {
  local win="$1"

  [[ -n $win ]] || return 0

  local win_mon=$(echo "$win" | cut -d'|' -f4 | xargs)
  local win_id=$(echo "$win" | cut -d'|' -f1 | xargs)
  local win_app=$(echo "$win" | cut -d'|' -f2 | xargs)
  local win_ws=$(echo "$win" | cut -d'|' -f5 | xargs)

  # Skip if the monitor is already the target monitor or if the workspace matches
  [[ $target_mon != "$win_mon" ]] && return 0
  [[ $ws == "$win_ws" ]] && return 0

  aerospace move-node-to-workspace --window-id "$win_id" "$ws"
}

# Process each PIP window found
for win in $pip_wins; do
  move_win "$win"
done
