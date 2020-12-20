from enum import Enum
from typing import List
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = "st"

layouts = [
    layout.Tile(ratio=0.5, margin=4, border_width=2),
    layout.VerticalTile(margin=4, border_width=2),
    layout.Max(margin=4, border_width=2)
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=6,
)

extension_defaults = widget_defaults.copy()

class Display(Enum):
    PRIMARY = 0
    SECONDARY = 1

class GroupContainer(Group):
    def __init__(
        self, 
        key: str, 
        display: Display, 
        label: str, 
        layout: str):
        self.key = key
        self.display = display
        super().__init__(
            name=key, 
            label=label, 
            layout=layout
        )

groupContainers = [
    GroupContainer(
        key="1",
        display=Display.PRIMARY,
        label="stuff", 
        layout="tile"
    ),
    GroupContainer(
        key="2",
        display=Display.PRIMARY,
        label="dev", 
        layout="max"
    ),
    GroupContainer(
        key="3",
        display=Display.PRIMARY,
        label="web", 
        layout="tile"
    ), 
    GroupContainer(
        key="4",
        display=Display.SECONDARY,
        label="work", 
        layout="verticaltile"
    ),
    GroupContainer(
        key="5",
        display=Display.SECONDARY,
        label="test", 
        layout="verticaltile"
    ),
]

groups = [ group for group in groupContainers ]

def go_to_group(container: GroupContainer):
    def function(qtile):
        qtile.cmd_to_screen(container.display.value)
        qtile.groupMap[container.key].cmd_toscreen()

    return function

keys = [
    Key([mod], "space", lazy.spawn("rofi -show drun")),
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "w", lazy.window.kill()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "r", lazy.restart()), 
    Key([mod, "shift"], "q", lazy.shutdown()),
]

for container in groupContainers:
    # keys.append(Key([mod], container.key, lazy.function(go_to_group(container))))
    keys.append(Key([mod], container.key, lazy.group[container.name].toscreen()))
    keys.append(Key([mod, "shift"], container.key, lazy.window.togroup(container.name, switch_group=True)))

def visible_groups_for(display: Display):
    return [
        container.key for container in list(
            filter(
                lambda container: container.display == display,
                groupContainers
            )
        )
    ]

primaryGroupBox = widget.GroupBox(visible_groups=visible_groups_for(display=Display.PRIMARY))
secondaryGroupBox = widget.GroupBox(visible_groups=visible_groups_for(display=Display.SECONDARY))

clock = widget.Clock(format='%Y-%m-%d %H:%M')

class TopBar(bar.Bar):
    def __init__(self, widgets):
        super().__init__(
            widgets=widgets,
            margin=[4, 4, 0, 4],
            size=24,
        )

screens = [
    Screen(
        top=TopBar(
            widgets=[
                widget.CurrentLayout(),
                primaryGroupBox,
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(),
                clock,
                widget.QuickExit(),
            ]
        ),
    ),
    Screen(
        top=TopBar(
            widgets=[
                widget.CurrentLayout(),
                secondaryGroupBox,
                widget.WindowName(),
                widget.Systray(),
                clock,
            ],
        ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'confirmreset'},  # gitk
        {'wmclass': 'makebranch'},  # gitk
        {'wmclass': 'maketag'},  # gitk
        {'wmclass': 'ssh-askpass'},  # ssh-askpass
        {'wname': 'branchdialog'},  # gitk
        {'wname': 'pinentry'},  # GPG key password entry
        {'wname': 'Picture-in-Picture'},
        # {'wname': 'Welcome to Android Studio'}
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "LG3D"
