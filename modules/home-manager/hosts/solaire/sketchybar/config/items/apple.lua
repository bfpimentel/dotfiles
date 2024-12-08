local settings = require("config.settings")

sbar.add("item", "apple", {
  background = {
    color = settings.colors.purple,
  },
  icon = { string = settings.icons.text.apple },
  label = { width = 0, padding_left = 0 },
  click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s 0"
})
