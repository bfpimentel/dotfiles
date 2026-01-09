#!/usr/bin/env bash

displays_count=$(yabai -m query --displays | jq '. | length')

function setup_space {
  local idx="$1"
  local name="$2"
  local display="$3"
  local space=

  space=$(yabai -m query --spaces --space "$idx")

  if [ -z "$space" ]; then
    echo "Creating space $idx"
    yabai -m space --create
  fi

  echo "Setting space $idx name to $name and display $display"
  yabai -m space "$idx" --label "$name" --display "$display"
}

if [ "$displays_count" -eq 1 ]; then
  # Spaces:          idx   name  display     description
  setup_space        1     B     1           # Browser
  setup_space        2     F     1           # Finder
  setup_space        3     M     1           # Music
  setup_space        4     S     1           # Simulator
  setup_space        5     T     1           # Terminal
  setup_space        6     W     1           # Work
  setup_space        7     X     1           # X
else
  # Spaces:          idx   name  display     description
  setup_space        1     S     1           # Simulator
  setup_space        2     T     1           # Terminal
  setup_space        3     X     1           # X
  setup_space        4     B     2           # Browser
  setup_space        5     F     2           # Finder
  setup_space        6     M     2           # Music
  setup_space        7     W     2           # Work
fi

# App rules
yabai -m rule --add app="^Finder$" space=F manage=off
yabai -m rule --add app="^YouTube Music$" space=M
yabai -m rule --add app="^Ghostty$" space=T
yabai -m rule --add app="^Simulator$" space=S
yabai -m rule --add app="^System Settings$" manage=off

# Window rules
yabai -m rule --add title="Helium - Bruno$" space=B
yabai -m rule --add title="Helium - Squibler$" space=W

# Manage Picture in Picture
function manage_pip {
  yabai -m window --focus $(yabai -m query --windows --space | jq '.[1].id // .[0].jd')
}
yabai -m signal --add event=display_changed action=manage_pip
yabai -m signal --add event=space_changed action=manage_pip

# Destroy spaces with index greater than N - 1. (N = number of spaces)
# Yabai wants to keep the Nth space anyway, so I destroy N - 1 to ensure there aren't any unlabeled spaces.
for idx in $(yabai -m query --spaces | jq '.[].index | select(. > 6)' | sort -nr); do
  echo "Destroying space space $idx"
  yabai -m space --destroy "$idx"
done

