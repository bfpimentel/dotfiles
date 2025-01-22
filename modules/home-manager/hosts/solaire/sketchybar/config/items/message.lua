local constants = require("constants")
local settings = require("config.settings")

local message = sbar.add("item", constants.items.MESSAGE, {
  width = 0,
  position = "center",
  popup = {
    drawing = true,
    align = "center",
    y_offset = -60,
  },
  label = {
    padding_left = 0,
    padding_right = 0,
  },
  background = {
    padding_left = 0,
    padding_right = 0,
  }
})

local messagePopup = sbar.add("item", {
  position = "popup." .. message.name,
  width = "dynamic",
  label = {
    padding_right = settings.dimens.padding.label,
    padding_left = settings.dimens.padding.label,
  },
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
})

local function hideMessage()
  sbar.animate("sin", 30, function()
    message:set({ popup = { y_offset = 12 } })
    message:set({ popup = { y_offset = -60 } })
  end)
end

local function showMessage(content, hold)
  hideMessage()

  messagePopup:set({ label = { string = content } })

  sbar.animate("sin", 30, function()
    message:set({ popup = { y_offset = -60 } })
    message:set({ popup = { y_offset = 12 } })
  end)

  if hold == false then
    sbar.delay(5, function()
      if hold then return end
      hideMessage()
    end)
  end
end

message:subscribe(constants.events.SEND_MESSAGE, function(env)
  local content = env.MESSAGE
  local hold = env.HOLD ~= nil and env.HOLD == "true" or false
  showMessage(content, hold)
end)

message:subscribe(constants.events.HIDE_MESSAGE, hideMessage)
