local colors = require("colors").sections.spaces
local icon_map = require("helpers.icon_map")

-- Check if this workspace is currently focused
local function is_focused_workspace(space_name, callback)
  Sbar.exec("aerospace list-workspaces --focused", function(focused)
    local current = focused:match("^%s*(.-)%s*$")
    callback(current == space_name)
  end)
end

local function add_windows(space, space_name)
  Sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    for app in windows:gmatch("[^\r\n]+") do
      local icon = icon_map[app] or icon_map["Default"]
      icon_line = icon_line .. " " .. icon
    end

    local label_text = icon_line == "" and "—" or icon_line
    local padding = icon_line == "" and 8 or 12

    Sbar.animate("tanh", 10, function()
      space:set({
        label = {
          string = label_text,
          padding_right = padding,
        },
        drawing = true,
      })
    end)

    -- Auto-hide if empty and not focused
    -- is_focused_workspace(space_name, function(is_focused)
    --   local should_draw = icon_line ~= "" or is_focused
    --   space:set({ drawing = true })
    -- end)
  end)
end

Sbar.exec("aerospace list-workspaces --all", function(output)
  for space_name in output:gmatch("[^\r\n]+") do
    local is_first = space_name == "1"

    local space = Sbar.add("item", "space." .. space_name, {
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
      padding_left = is_first and 0 or 4,
      drawing = false, -- hide by default until checked
    })

    add_windows(space, space_name)

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      space:set({
        icon = { highlight = selected },
        label = { highlight = selected },
      })

      if selected then
        Sbar.animate("tanh", 8, function()
          space:set({
            background = { shadow = { distance = 0 } },
            y_offset = -4,
            padding_left = 8,
            padding_right = 0,
          })
          space:set({
            background = { shadow = { distance = 4 } },
            y_offset = 0,
            padding_left = 4,
            padding_right = 4,
          })
        end)
      end

      -- Always make focused space visible
      space:set({ drawing = true })
    end)

    space:subscribe("space_windows_change", function()
      add_windows(space, space_name)
    end)

    space:subscribe("mouse.clicked", function()
      Sbar.animate("tanh", 8, function()
        space:set({
          background = { shadow = { distance = 0 } },
          y_offset = -4,
          padding_left = 8,
          padding_right = 0,
        })
        space:set({
          background = { shadow = { distance = 4 } },
          y_offset = 0,
          padding_left = 4,
          padding_right = 4,
        })
      end)
    end)
  end
end)
