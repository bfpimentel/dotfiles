local colors = require("colors").sections.spaces
local icons = require("icons")

local spaces_indicator = Sbar.add("item", {
  icon = {
    padding_left = 8,
    padding_right = 9,
    string = icons.switch.on,
    color = colors.indicator,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
  },
  padding_right = 8,
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.clicked", function()
  Sbar.animate("tanh", 8, function()
    spaces_indicator:set({
      background = { shadow = { distance = 0 } },
      y_offset = -4,
      padding_left = 8,
      padding_right = 4,
    })
    spaces_indicator:set({
      background = { shadow = { distance = 4 } },
      y_offset = 0,
      padding_left = 4,
      padding_right = 8,
    })
  end)

  Sbar.trigger("swap_menus_and_spaces")
end)
