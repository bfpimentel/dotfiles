from libqtile import layout
from libqtile.config import Match
from settings.theme import theme

layout_conf = {
    'border_focus': theme['focus'][0],
    'border_width': 2,
    'margin': 8,
}

layouts = [
    layout.Tile(**layout_conf, ratio=0.5, name='tile'),
    layout.VerticalTile(**layout_conf, name='verticaltile'),
    #layout.Max(name='max'),
]

floating_layout = layout.Floating(
    float_rules=[
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'confirmreset'},
        {'wmclass': 'makebranch'},
        {'wmclass': 'maketag'},
        {'wmclass': 'ssh-askpass'},
        {'wname': 'branchdialog'},
        {'wname': 'pinentry'},
        {'wname': 'Picture-in-Picture'},
    ],
    border_focus=theme['color4'][0]
)
