local constants = require("constants")
local settings = require("config.settings")

local calendar = sbar.add("item", constants.items.CALENDAR, {
  position = "right",
  update_freq = 1,
  label = { color = settings.colors.white },
  icon = { drawing = false },
})

calendar:subscribe({ "forced", "routine", "system_woke" }, function(env)
  calendar:set({
    label = os.date("%a %d %b, %H:%M"),
  })
end)

calendar:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Calendar'")
end)
