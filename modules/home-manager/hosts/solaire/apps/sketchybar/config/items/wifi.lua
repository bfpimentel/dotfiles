local icons = require("icons")
local colors = require("colors").sections.widgets.wifi

local popup_width = 250

local wifi = Sbar.add("item", "wifi", {
  position = "right",
  icon = {
    color = colors.icon,
    padding_left = 8,
  },
  label = {
    padding_right = 8,
  },
  popup = {
    align = "center",
    height = 30,
    y_offset = 2,
  },
})

local ip = Sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  },
  background = { drawing = false },
})

local router = Sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "Router:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  },
  background = { drawing = false },
})

wifi:subscribe({ "wifi_change", "system_woke", "forced" }, function()
  Sbar.exec(
    "networksetup -listpreferredwirelessnetworks en0 | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'",
    function(result)
      local ssid = result:gsub("\n", "")
      local is_connected = not (ssid == "")

      if not is_connected then
        ssid = "Not connected"
      end

      wifi:set({
        icon = {
          string = is_connected and icons.wifi.connected or icons.wifi.disconnected,
        },
        label = {
          string = is_connected and ssid or "",
        },
      })

      Sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
        local is_vpn_connected = not (vpn == "")

        if is_vpn_connected then
          wifi:set({
            icon = {
              string = icons.wifi.vpn,
              color = colors.active,
            },
          })
        end
      end)
    end
  )
end)

local function hide_details()
  wifi:set({ popup = { drawing = false } })
end

local function toggle_details()
  local should_draw = wifi:query().popup.drawing == "off"
  if should_draw then
    wifi:set({ popup = { drawing = true } })
    Sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result })
    end)
    Sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result })
    end)
  else
    hide_details()
  end
end

wifi:subscribe("mouse.clicked", function()
  Sbar.animate("tanh", 8, function()
    wifi:set({
      background = {
        shadow = {
          distance = 0,
        },
      },
      y_offset = -4,
      padding_left = 4,
      padding_right = 0,
    })
    wifi:set({
      background = {
        shadow = {
          distance = 4,
        },
      },
      y_offset = 0,
      padding_left = 0,
      padding_right = 4,
    })
  end)
  toggle_details()
end)

-- wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = Sbar.query(env.NAME).label.value
  Sbar.exec('echo "' .. label .. '" | pbcopy')
  Sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
  Sbar.delay(1, function()
    Sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

ip:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
