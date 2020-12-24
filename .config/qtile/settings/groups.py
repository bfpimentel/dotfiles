from libqtile.config import Group, Match

groups = [
    Group(name="web", label="[ web  ]", matches=[Match(wm_class=["firefox_bruno"])]),
    Group(name="term", label="[ term  ]", matches=[Match(wm_class=["Alacritty"])]),
    Group(name="dev", label="[ dev   ﯤ ]", matches=[Match(wm_class=["jetbrains-studio"])]),
    Group(name="discord", label="[ discord ﭮ ]", matches=[Match(wm_class=["discord"])]),
    Group(name="spotify", label="[ spotify  ]", matches=[Match(wm_class=["spotify", "Spotify"], title="Spotify Premium")]),
    Group(name="work", label="[ work 華 ]", matches=[Match(wm_class=["firefox_work", "slack"])]),
]
