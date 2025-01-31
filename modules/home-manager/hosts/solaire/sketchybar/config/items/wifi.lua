local icons = require "icons"
local colors = require("colors").sections.widgets.wifi

sbar.exec(
  "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local popup_width = 250

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  padding_right = 8,
  padding_left = 0,
  icon = {
    color = colors.icon,
    padding_left = 8
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

local ip = sbar.add("item", {
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

local router = sbar.add("item", {
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
  sbar.exec([[ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}']], function(wifi_name)
    local is_connected = not (wifi_name == "")
    wifi:set {
      icon = {
        string = is_connected and icons.wifi.connected or icons.wifi.disconnected,
      },
      label = {
        string = is_connected and wifi_name or "",
      }
    }

    sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
      local is_vpn_connected = not (vpn == "")

      if is_vpn_connected then
        wifi:set {
          icon = {
            string = icons.wifi.vpn,
            color = colors.green,
          },
        }
      end
    end)
  end)
end)

local function hide_details()
  wifi:set { popup = { drawing = false } }
end

local function toggle_details()
  local should_draw = wifi:query().popup.drawing == "off"
  if should_draw then
    wifi:set { popup = { drawing = true } }
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set { label = result }
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set { label = result }
    end)
  else
    hide_details()
  end
end

wifi:subscribe("mouse.clicked", function()
  sbar.animate("tanh", 8, function()
    wifi:set({
      background = {
        shadow = {
          distance = 0,
        },
      },
      y_offset = -4,
      padding_left = 4,
      padding_right = 4,
    })
    wifi:set({
      background = {
        shadow = {
          distance = 4,
        },
      },
      y_offset = 0,
      padding_left = 0,
      padding_right = 8,
    })
  end)
  toggle_details()
end)

-- wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec('echo "' .. label .. '" | pbcopy')
  sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

ip:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
