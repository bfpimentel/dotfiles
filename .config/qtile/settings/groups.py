from libqtile.config import Group, Match

groups = [
    Group(name="term", label="", matches=[Match(wm_class="kitty"), Match(wm_class="jetbrains-studio")]),
    Group(name="web", label="", matches=[Match(wm_class="firefox_bruno")]),
    Group(name="planning", label="", matches=[Match(wm_class="Todoist")]),
    Group(name="discord", label="ﭮ", matches=[Match(wm_class="discord")]),
    Group(name="spotify", label="", matches=[Match(wm_class="spotify")]),
    Group(name="work", label="", matches=[Match(wm_class="firefox_work"), Match(wm_class="slack")]),
]
