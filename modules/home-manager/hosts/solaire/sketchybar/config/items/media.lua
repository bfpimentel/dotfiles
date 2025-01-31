local icons = require("icons")
local colors = require("colors").sections.media

local whitelist = { ["Spotify"] = true, ["Psst"] = true }

local media_playback = sbar.add("item", {
  position = "right",
  icon = {
    string = icons.music,
    color = colors.label,
    padding_left = 8,
  },
  label = {
    max_chars = 50,
    padding_right = 8,
  },
  popup = {
    horizontal = true,
    align = "center",
    y_offset = 2,
  },
  padding_right = 8,
})

sbar.add("item", {
  position = "popup." .. media_playback.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.back },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "nowplaying-cli previous",
})

sbar.add("item", {
  position = "popup." .. media_playback.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})

sbar.add("item", {
  position = "popup." .. media_playback.name,
  padding_left = 6,
  padding_right = 6,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "nowplaying-cli next",
})

media_playback:subscribe("media_change", function(env)
  if whitelist[env.INFO.app] then
    local is_playing = (env.INFO.state == "playing")
    media_playback:set {
      drawing = is_playing,
      label = {
        string = env.INFO.artist .. " - " .. env.INFO.title,
        padding_left = is_playing and 8 or 0,
      },
    }
  end
end)

media_playback:subscribe("mouse.clicked", function(_)
  sbar.animate("tanh", 8, function()
    media_playback:set {
      background = {
        shadow = {
          distance = 0,
        },
      },
      y_offset = -4,
      padding_left = 8,
      padding_right = 4,
    }
    media_playback:set {
      background = {
        shadow = {
          distance = 4,
        },
      },
      y_offset = 0,
      padding_left = 4,
      padding_right = 8,
    }
  end)
  media_playback:set { popup = { drawing = "toggle" } }
end)
