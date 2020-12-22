from libqtile import widget, bar
from settings.theme import theme, font
from widgets.pacman_updates import PacmanUpdates

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
        **base(foreground='light'),
        #font=font['bold'],
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
    widget.Spacer(length=bar.STRETCH),
]

primary_widgets = [
    *workspaces(),
    icon(background="color2", text=' '),
    widget.CurrentLayout(**base(background='color2'), padding=8),
    icon(background="color4", text=' '),
    PacmanUpdates(
        background=theme['color4'],
        colour_no_updates=theme['dark'],
        colour_have_updates=theme['dark'],
        update_interval=60,
        padding=8,
    ),
    icon(background="color1", text=' '),
    widget.Clock(**base(background='color1'), format='%d/%m/%Y - %H:%M', padding=8),
    widget.Systray(background=theme['dark'], padding=8),
]

secondary_widgets = [
    *workspaces(),
    icon(background="color2", text=' '),
    widget.CurrentLayout(**base(background='color2'), padding=8),
]

widget_defaults = {
    'font': font['regular'],
    'fontsize': 14,
    'padding': 1,
}

extension_defaults = widget_defaults.copy()

