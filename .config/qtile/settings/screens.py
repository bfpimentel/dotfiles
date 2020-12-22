from libqtile.config import Screen
from libqtile import bar
from settings.widgets import primary_widgets, secondary_widgets

import subprocess

status_bar = lambda widgets: bar.Bar(widgets=widgets, size=24, opacity=1, margin=[8, 8, 0, 8])

screens = [Screen(top=status_bar(primary_widgets))]

connected_monitors = subprocess.run(
   "xrandr | grep 'connected' | cut -d ' ' -f 2",
    shell=True,
    stdout=subprocess.PIPE
).stdout.decode("UTF-8").split("\n")[:-1].count("connected")

if (connected_monitors > 1):
    for index in range(1, connected_monitors):
        screens.append(Screen(top=status_bar(secondary_widgets)))

