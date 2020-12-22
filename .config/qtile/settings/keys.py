from libqtile.config import Key
from libqtile.command import lazy
from settings.groups import groups

mod = "mod4"

keys = [Key(tuple[0], tuple[1], *tuple[2:]) for tuple in [
    # Qtile
    ([mod, "control"], "r", lazy.restart()),
    ([mod, "control"], "q", lazy.shutdown()),

    # Switch between windows
    ([mod], "Down", lazy.layout.down()),
    ([mod], "Up", lazy.layout.up()),
    ([mod], "Left", lazy.layout.left()),
    ([mod], "Right", lazy.layout.right()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows
    ([mod, "shift"], "Down", lazy.layout.shuffe_down()),
    ([mod, "shift"], "Up", lazy.layout.shuffe_up()),

    # Toggle layouts
    ([mod], "Tab", lazy.next_layout()),

    # Kill Window
    ([mod], "w", lazy.window.kill()),

    # Switch Screens
    ([mod, "shift"], "Left", lazy.prev_screen()),
    ([mod, "shift"], "Right", lazy.next_screen()),

    # Alacritty  
    ([mod], "Return", lazy.spawn("alacritty")),

    # Rofi
    ([mod], "space", lazy.spawn("rofi -show drun")),
    ([mod, "shift"], "space", lazy.spawn("rofi -show")),

    # Flameshot
    ([mod], "p", lazy.spawn("flameshot gui")),
    ([mod, "shift"], "p", lazy.spawn("flameshot screen -r -c")),
]]

for index, group in enumerate(groups):
    key = str(index + 1)
    keys.append(Key([mod], key, lazy.group[group.name].toscreen()))
    keys.append(Key([mod, "shift"], key, lazy.window.togroup(group.name)))

