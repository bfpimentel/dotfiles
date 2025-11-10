Sbar = require("sketchybar")

Sbar.begin_config()
Sbar.hotload(true)

require("bar")
require("default")
require("items")

Sbar.end_config()
Sbar.event_loop()
