local colors = require("colors").sections.spaces
local icons = require("icons")
local icon_map = require("helpers.icon_map")

local function add_windows(space, space_name)
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    for app in windows:gmatch "[^\r\n]+" do
      local lookup = icon_map[app]
      local icon = ((lookup == nil) and icon_map["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    sbar.animate("tanh", 10, function()
      space:set {
        label = {
          string = icon_line == "" and "—" or icon_line,
          padding_right = icon_line == "" and 8 or 12,
        },
      }
    end)
  end)
end

sbar.exec("aerospace list-workspaces --all", function(spaces)
  for space_name in spaces:gmatch "[^\r\n]+" do
    local space = sbar.add("item", "space." .. space_name, {
      icon = {
        string = space_name,
        color = colors.icon.color,
        highlight_color = colors.icon.highlight,
        padding_left = 8,
      },
      label = {
        font = "sketchybar-app-font:Regular:14.0",
        string = "",
        color = colors.label.color,
        highlight_color = colors.label.highlight,
        y_offset = -1,
      },
      click_script = "aerospace workspace " .. space_name,
      padding_left = space_name == "1" and 0 or 4,
    })

    add_windows(space, space_name)

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      space:set {
        icon = { highlight = selected },
        label = { highlight = selected },
      }

      if selected then
        sbar.animate("tanh", 8, function()
          space:set {
            background = {
              shadow = {
                distance = 0,
              },
            },
            y_offset = -4,
            padding_left = 8,
            padding_right = 0,
          }
          space:set {
            background = {
              shadow = {
                distance = 4,
              },
            },
            y_offset = 0,
            padding_left = 4,
            padding_right = 4,
          }
        end)
      end
    end)

    space:subscribe("space_windows_change", function()
      add_windows(space, space_name)
    end)

    space:subscribe("mouse.clicked", function()
      sbar.animate("tanh", 8, function()
        space:set {
          background = {
            shadow = {
              distance = 0,
            },
          },
          y_offset = -4,
          padding_left = 8,
          padding_right = 0,
        }
        space:set {
          background = {
            shadow = {
              distance = 4,
            },
          },
          y_offset = 0,
          padding_left = 4,
          padding_right = 4,
        }
      end)
    end)
  end
end)

local spaces_indicator = sbar.add("item", {
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
  spaces_indicator:set {
    icon = currently_on and icons.switch.off or icons.switch.on,
  }
end)

spaces_indicator:subscribe("mouse.clicked", function()
  sbar.animate("tanh", 8, function()
    spaces_indicator:set {
      background = {
        shadow = {
          distance = 0,
        },
      },
      y_offset = -4,
      padding_left = 8,
      padding_right = 4,
    }
    spaces_indicator:set {
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

  sbar.trigger("swap_menus_and_spaces")
end)
