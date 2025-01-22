local constants = require("constants")
local settings = require("config.settings")

local popupWidth = settings.dimens.graphics.popup.width + 20

sbar.add("item", {
  position = "right",
  width = settings.dimens.padding.label
})

local wifi = sbar.add("item", constants.items.WIFI, {
  position = "right",
  padding_right = 0,
  label = {
    string = "",
    padding_left = 0,
  },
})

local ip = sbar.add("item", {
  position = "popup." .. wifi.name,
  background = {
    height = 16,
  },
  icon = {
    align = "left",
    string = "IP:",
    width = popupWidth / 2,
    font = {
      size = settings.dimens.text.label
    },
  },
  label = {
    align = "right",
    string = "???.???.???.???",
    width = popupWidth / 2,
  }
})

local router = sbar.add("item", {
  position = "popup." .. wifi.name,
  background = {
    height = 16,
  },
  icon = {
    align = "left",
    string = "Router:",
    width = popupWidth / 2,
    font = {
      size = settings.dimens.text.label
    },
  },
  label = {
    align = "right",
    string = "???.???.???.???",
    width = popupWidth / 2,
  },
})

wifi:subscribe({ "wifi_change", "system_woke", "forced" }, function()
  wifi:set({ icon = { string = settings.icons.text.wifi.disconnected } })

  sbar.exec([[ipconfig getifaddr en0]], function(ipAddress)
    if ipAddress == "" then
      wifi:set({
        icon = settings.icons.text.wifi.disconnected,
        label = {
          string = "",
          padding_left = 8,
        },
      })
      return
    end

    sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
      sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(ssid)
        local isVPNConnected = not (vpn == "")
        local wifiLabel = isVPNConnected and ssid .. " [VPN]" or ssid

        wifi:set({
          label = {
            string = wifiLabel,
            padding_left = 8,
          },
          icon = settings.icons.text.wifi.connected,
        })
      end)
    end)
  end)
end)

local function hideDetails()
  wifi:set({ popup = { drawing = false } })
end

local function toggleDetails()
  local shouldDrawDetails = wifi:query().popup.drawing == "off"

  if shouldDrawDetails then
    wifi:set({ popup = { drawing = true } })
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result })
    end)
  else
    hideDetails()
  end
end

local function copyLabelToClipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec("echo \"" .. label .. "\" | pbcopy")
  sbar.set(env.NAME, { label = { string = settings.icons.text.clipboard, align = "center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

wifi:subscribe("mouse.clicked", toggleDetails)

ip:subscribe("mouse.clicked", copyLabelToClipboard)
router:subscribe("mouse.clicked", copyLabelToClipboard)
