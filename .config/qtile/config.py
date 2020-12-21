from libqtile import hook

from settings.widgets import widget_defaults, extension_defaults
from settings.keys import mod, keys
from settings.groups import groups
from settings.layouts import layouts, floating_layout
from settings.screens import screens
from settings.mouse import mouse

main = None
dgroups_key_bindger = None
dgroups_app_rules = []
follow_mouse_focus = False
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = 'urgent'
wmname = 'LG3D'
