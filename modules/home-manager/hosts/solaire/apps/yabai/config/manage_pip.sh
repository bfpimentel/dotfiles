#!/bin/bash

space_windows=$(yabai -m query --windows --space)
focused_window_is_pip=$(jq 'map(select(."has-focus" and .title == "Picture in Picture")) | length' <<< "$space_windows")

if [[ $focused_window_is_pip -eq 1 ]]; then
    winid=$(jq 'map(select(."has-focus" and .title == "Picture in Picture" | not)) | .[0].id' <<< "$space_windows")
    if [[ "$winid" != 'null' ]]; then
        yabai -m window --focus $winid
    fi
fi
