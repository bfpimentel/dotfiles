sbar = require("sketchybar")

sbar.begin_config()
sbar.hotload(true)

require("bar")
require("default")
require("items")

sbar.end_config()
sbar.event_loop()
