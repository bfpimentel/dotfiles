from libqtile.config import Group, Match

groups = [
    Group(name="term", label="", matches=[Match(wm_class=["Alacritty"]), Match(wm_class=["jetbrains-studio"])]),
    Group(name="web", label="", matches=[Match(wm_class=["firefox_bruno"])]),
    Group(name="rss", label="", matches=[Match(wm_class=["feedreader"])]),
    Group(name="discord", label="ﭮ", matches=[Match(wm_class=["discord"])]),
    Group(name="spotify", label="", matches=[Match(wm_class=["spotify", "Spotify"], title="Spotify Premium")]),
    Group(name="work", label="華", matches=[Match(wm_class=["firefox_work", "slack"])]),
]
