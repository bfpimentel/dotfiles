from libqtile import widget, bar, qtile
from settings.theme import theme, font
from widgets.pacman_updates import PacmanUpdates
from widgets.caps_lock_indicator import CapsLockIndicator

def open_power_menu():
    qtile.cmd_spawn("rofi -show power-menu -modi power-menu:.config/rofi/extensions/power-menu")

transparent = '#00000000'

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
        fontsize=20,
        padding=10,
        margin_x=0,
        borderwidth=3,
        rounded=True,
        disable_drag=True,
        use_mouse_wheel=False,
        highlight_method='block',
        urgent_alert_method='block',
        urgent_border=theme['urgent'],
        this_current_screen_border=theme['color3'],
        this_screen_border=theme['color1'],
        other_current_screen_border=theme['dark'],
        other_screen_border=theme['dark'],
        active=theme['active'],
        inactive=theme['inactive'],
    ),
    widget.Spacer(length=bar.STRETCH),
    #icon(background='light', foreground='dark', text=' '),
    #widget.CurrentLayout(**base(background='light', foreground='dark'), padding=8),
    #widget.Spacer(length=bar.STRETCH),
    CapsLockIndicator(),
    widget.Spacer(length=4),
    widget.Systray(**base(background='dark'), padding=8, icon_size=16),
    widget.Spacer(**base(background='dark'), length=8),
    icon(background="dark", text=' '),
    PacmanUpdates(
        background=theme['dark'],
        colour_no_updates=theme['light'],
        colour_have_updates=theme['light'],
        update_interval=60,
        padding=8,
        display_format="{updates}",
    ),
    widget.Clock(**base(background='dark'), format=' %d/%m/%Y  %H:%M', padding=8),
    widget.TextBox(
        **base(background='dark', foreground='light'),
        text="",
        fontsize=16,
        padding=8,
        mouse_callbacks={"Button1": open_power_menu},
    ),
]

primary_widgets = [
    *workspaces(),
]

secondary_widgets = [
    *workspaces(),
]

widget_defaults = {
    'font': font['regular'],
    'fontsize': 14,
    'padding': 4,
}

extension_defaults = widget_defaults.copy()

