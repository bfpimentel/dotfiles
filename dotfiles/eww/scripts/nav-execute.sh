#!/usr/bin/env bash
# Execute the currently selected menu item

selected=$(eww get selected-index 2>/dev/null || echo "0")


# (button :class {selected-index == 0 ? "menu-item selected" : "menu-item"}
#         :onclick "wofi --show drun & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰀻  Applications"))
# (button :class {selected-index == 1 ? "menu-item selected" : "menu-item"}
#         :onclick "python3 ~/.config/sway/bitwarden-menu.py & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰟵  Bitwarden"))
# (button :class {selected-index == 2 ? "menu-item selected" : "menu-item"}
#         :onclick "python3 ~/.config/sway/clipboard-menu.py & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰅌  Clipboard"))
# (button :class {selected-index == 3 ? "menu-item selected" : "menu-item"}
#         :onclick "python3 ~/.config/sway/processes-menu.py & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰍹  Processes"))
# (button :class {selected-index == 4 ? "menu-item selected" : "menu-item"}
#         :onclick "python3 ~/.config/sway/screenshot-menu.py & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰄄  Screenshots"))
# (button :class {selected-index == 5 ? "menu-item selected" : "menu-item"}
#         :onclick "python3 ~/.config/sway/session-menu.py & eww close dashboard"
#         (label :xalign 0 :hexpand true :text "󰐥  Session")))))

case "$selected" in
    0) wofi --show drun & ;;
    1) python3 ~/.config/sway/bitwarden-menu.py & ;;
    2) python3 ~/.config/sway/clipboard-menu.py & ;;
    3) python3 ~/.config/sway/processes-menu.py & ;;
    4) python3 ~/.config/sway/screenshot-menu.py & ;;
    5) python3 ~/.config/sway/session-menu.py & ;;
esac

echo "0"
