from libqtile import widget, bar
from settings.theme import theme, font
from widgets.pacman_updates import PacmanUpdates
from widgets.caps_lock_indicator import CapsLockIndicator

trasnparent = '#000000'

base = lambda foreground='text', background='dark': {
    'foreground': theme[foreground],
    'background': theme[background],
}

icon = lambda text, foreground='text', background='dark', fontsize=16: widget.TextBox(
    **base(foreground=foreground, background=background),
    fontsize=fontsize,
    text=text,
    padding=0
)

workspaces = lambda: [
    widget.GroupBox(
        **base(foreground='light', background='dark'),
        fontsize=22,
        margin_y=3,
        margin_x=0,
        padding_y=8,
        padding_x=5,
        borderwidth=2,
        rounded=False,
        disable_drag=True,
        use_mouse_wheel=False,
        highlight_method='line',
        urgent_alert_method='line',
        urgent_border=theme['urgent'],
        this_current_screen_border=theme['focus'],
        this_screen_border=theme['light'],
        other_current_screen_border=theme['dark'],
        other_screen_border=theme['dark'],
        active=theme['active'],
        inactive=theme['inactive'],
    ),
    icon(background='light', foreground='dark', text=' '),
    widget.CurrentLayout(**base(background='light', foreground='dark'), padding=8),
    widget.Spacer(length=bar.STRETCH),
    CapsLockIndicator(),
    widget.Spacer(length=4),
]

def _open_power_menu(qtile):
    qtile.cmd_spawn("rofi -show power-menu -modi power-menu:.config/rofi/extensions/power-menu")

primary_widgets = [
    *workspaces(),
    widget.Systray(**base(background='dark'), padding=8, icon_size=16),
    widget.Spacer(**base(background='dark'), length=8),
    icon(background="color3", text=' '),
    PacmanUpdates(
        background=theme['color3'],
        colour_no_updates=theme['light'],
        colour_have_updates=theme['light'],
        update_interval=60,
        padding=8,
        display_format="{updates}",
    ),
    widget.Clock(**base(background='color1'), format=' %d/%m/%Y  %H:%M', padding=8),
    widget.TextBox(
        **base(background='light', foreground='dark'),
        text="",
        fontsize=18,
        padding=8,
        mouse_callbacks={"Button1": _open_power_menu},
    ),
]

secondary_widgets = [
    *workspaces(),
]

widget_defaults = {
    'font': font['regular'],
    'fontsize': 14,
    'padding': 1,
}

extension_defaults = widget_defaults.copy()

