#!/usr/bin/env bash

TMUXDIR="$HOME/.config/tmux"
LAYOUTDIR="$TMUXDIR/layouts"
SCRIPT_DIR=$(dirname "$(realpath "$0")")
LIST_LAYOUTS="$SCRIPT_DIR/list-layouts.sh"

find_layout() {
    local selected="$1"
    local layout
    local name

    for layout in "$LAYOUTDIR"/*; do
        [[ -x "$layout" && -f "$layout" ]] || continue

        name=$("$layout" --name 2>/dev/null)
        [[ -n "$name" ]] || name=$(basename "$layout")

        if [[ "$name" == "$selected" ]]; then
            printf "%s\n" "$layout"
            return 0
        fi
    done

    return 1
}

run_layout() {
    local selected="$1"
    local path_to_layout

    path_to_layout=$(find_layout "$selected")

    if [[ -z "$path_to_layout" ]]; then
        tmux display-message "Unknown layout: $selected"
        exit 1
    fi

    tmux run-shell "$path_to_layout"
}

if [[ -z "$1" ]]; then
    SCRIPT_PATH=$(realpath "$0")
    tmux display-popup -E -h 30% -w 50% "layout=\$(\"$LIST_LAYOUTS\" | fzf --header='Select Layout' --reverse); [[ -n \"\$layout\" ]] && tmux run-shell \"\\\"$SCRIPT_PATH\\\" \\\"\$layout\\\"\""
    exit 0
fi

PANE_COUNT=$(tmux display-message -p "#{window_panes}")

if [[ "$PANE_COUNT" != "1" ]]; then
    tmux display-message "This layout must start from a single-pane window. Current panes: $PANE_COUNT"
    exit 1
fi

run_layout "$1"
