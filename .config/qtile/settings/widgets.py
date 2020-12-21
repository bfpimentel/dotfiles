from libqtile import widget
from settings.theme import theme, font

base = lambda foreground='text', background='dark': {
    'foreground': theme[foreground],
    'background': theme[background],
}

separator = lambda: widget.Sep(**base(), linewidth=0, padding=5)

icon = lambda foreground='text', background='dark', fontsize=16, text='': widget.TextBox(
    **base(foreground=foreground, background=background),
    fontsize=fontsize,
    text=text,
    padding=3
)

workspaces = lambda: [
    separator(),
    widget.GroupBox(
        **base(foreground='light'),
        # font='',
        fontsize=14,
        margin_y=3,
        margin_x=0,
        padding_y=8,
        padding_x=5,
        borderwidth=1,
        active=theme['active'],
        inactive=theme['inactive'],
        rounded=False,
        highlight_method='block',
        urgent_alert_method='block',
        urgent_border=theme['urgent'],
        this_current_screen_border=theme['focus'],
        this_screen_border=theme['grey'],
        other_current_screen_border=theme['dark'],
        other_screen_border=theme['dark'],
        disable_drag=True
    ),
    separator(),
    widget.WindowName(**base(foreground='focus'), fontsize=14, padding=5),
    separator(),
]

primary_widgets = [
    *workspaces(),
    separator(),
    icon(background="color4", text=' '),
    widget.Pacman(**base(background='color4'), update_interval=1800, padding=5),
    widget.CurrentLayoutIcon(**base(background='color2'), scale=0.65),
    widget.CurrentLayout(**base(background='color2'), padding=5),
    icon(background="color1", fontsize=17, text=' '),
    widget.Clock(**base(background='color1'), format='%d/%m/%Y - %H:%M '),
    widget.Systray(background=theme['dark'], padding=5),
]

secondary_widgets = [
    *workspaces(),
    separator(),
    widget.CurrentLayoutIcon(**base(background='color1'), scale=0.65),
    widget.CurrentLayout(**base(background='color1'), padding=5),
]

widget_defaults = {
    'font': 'Hack Nerd Font Mono',
    'fontsize': 14,
    'padding': 1,
}

extension_defaults = widget_defaults.copy()

