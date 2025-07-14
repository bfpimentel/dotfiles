local notification = sbar.add("item", "notifications", {
  width = 0,
  position = "center",
  popup = {
    drawing = true,
    align = "center",
    y_offset = -80,
  },
})

local notification_popup = sbar.add("item", {
  position = "popup." .. notification.name,
  width = "dynamic",
  icon = { drawing = false },
  background = { drawing = false },
})

local function hide_notification()
  sbar.animate("sin", 30, function()
    notification:set({ popup = { y_offset = 2 } })
    notification:set({ popup = { y_offset = -80 } })
  end)
end

local function show_notification(content, hold)
  hide_notification()

  notification_popup:set({ label = { string = content } })

  sbar.animate("sin", 30, function()
    notification:set({ popup = { y_offset = -80 } })
    notification:set({ popup = { y_offset = 2 } })
  end)

  if hold == false then
    sbar.delay(5, function()
      if hold then return end
      hide_notification()
    end)
  end
end

notification:subscribe("send_message", function(env)
  local content = env.MESSAGE
  local hold = env.HOLD ~= nil and env.HOLD == "true" or false
  show_notification(content, hold)
end)

notification:subscribe("hide_message", hide_notification)
