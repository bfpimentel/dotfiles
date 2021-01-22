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
    layout.VerticalTile(**layout_conf, name='vtile'),
    #layout.Max(name='max'),
]

floating_layout = layout.Floating(
    float_rules=[
        Match(wm_type="utility"),
        Match(wm_type="notification"),
        Match(wm_type="toolbar"),
        Match(wm_type="splash"),
        Match(wm_type="dialog"),
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(title='Picture-in-Picture'),
    ],
    border_focus=theme['focus'][0]
)
