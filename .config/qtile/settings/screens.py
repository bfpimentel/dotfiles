from libqtile.config import Screen
from libqtile import bar
from settings.widgets import primary_widgets, secondary_widgets

status_bar = lambda widgets: bar.Bar(widgets=widgets, size=24, opacity=1, margin=0)

screens = [
    Screen(top=status_bar(primary_widgets)),
    Screen(top=status_bar(secondary_widgets)),
]

