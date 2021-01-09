from libqtile.config import Key
from libqtile.lazy import lazy
from settings.groups import groups

mod = "mod4"

keys = [
    # Qtile
    Key([mod, "mod1"], "r", lazy.restart()),
    Key([mod, "mod1"], "q", lazy.shutdown()),

    # Switch between windows
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),

    # Toggle floating
    Key([mod], "f", lazy.window.toggle_floating()),

    # Move windows
    Key([mod, "shift"], "Down", lazy.layout.shuffe_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffe_up()),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),

    # Toggle layouts
    Key([mod], "Tab", lazy.next_layout()),

    # Switch Screens
    Key([mod, "mod1"], "Tab", lazy.next_screen()),

    # Kill Window
    Key([mod], "w", lazy.window.kill()),

    # Alacritty  
    Key([mod], "Return", lazy.spawn("kitty")),

    # Rofi
    Key([mod], "space", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "space", lazy.spawn("rofi -show")),

    # Flameshot
    Key([mod], "p", lazy.spawn("flameshot gui")),
    Key([mod, "shift"], "p", lazy.spawn("flameshot screen -r -c")),
    Key([mod, "mod1"], "p", lazy.spawn("flameshot screen -r -p ~/Pictures")),
]

for key, group in enumerate(groups, 1):
    keys.append(Key([mod], str(key), lazy.group[group.name].toscreen()))
    keys.append(Key([mod, "shift"], str(key), lazy.window.togroup(group.name)))

