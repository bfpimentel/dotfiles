from libqtile.config import Key
from libqtile.lazy import lazy
from settings.groups import groups

mod = "mod4"

keys = [
    # Qtile
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),

    # Switch between windows
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),

    # Toggle floating
    Key([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows
    Key([mod, "shift"], "Down", lazy.layout.shuffe_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffe_up()),

    # Toggle layouts
    Key([mod], "Tab", lazy.next_layout()),

    # Kill Window
    Key([mod], "w", lazy.window.kill()),

    # Switch Screens
    Key([mod, "shift"], "Left", lazy.prev_screen()),
    Key([mod, "shift"], "Right", lazy.next_screen()),

    # Alacritty  
    Key([mod], "Return", lazy.spawn("alacritty")),

    # Rofi
    Key([mod], "space", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "space", lazy.spawn("rofi -show")),

    # Flameshot
    Key([mod], "p", lazy.spawn("flameshot gui")),
    Key([mod, "shift"], "p", lazy.spawn("flameshot screen -r -c")),
]

for key, group in enumerate(groups, 1):
    keys.append(Key([mod], str(key), lazy.group[group.name].toscreen()))
    #keys.append(Key([mod], str(key), _go_to_group(group)))
    keys.append(Key([mod, "shift"], str(key), lazy.window.togroup(group.name)))

