local constants = require("constants")
local settings = require("config.settings")

local maxItems = 15
local menuItems = {}

local isShowingMenu = false

local frontAppWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local menu = sbar.add("item", constants.items.MENU, {
  updates = true,
  position = "left",
  width = 0,
  padding_left = 0,
  padding_right = 0,
  label = { drawing = false },
  background = { drawing = false },
  popup = { align = "left" }
})

local function createPlaceholders()
  for index = 1, maxItems, 1 do
    local menuItem = sbar.add("item", {
      position = "popup." .. menu.name,
      drawing = false,
      icon = { drawing = false },
      width = "dynamic",
      label = {
        width = 100,
        font = {
          style = index == 1 and settings.fonts.styles.bold or settings.fonts.styles.regular,
        },
      },
      click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s " .. index,
    })
    menuItems[index] = menuItem
  end
end

local function updateMenus()
  sbar.set("/popup." .. constants.items.MENU .. "\\..*/", { drawing = false })
  menu:set({ popup = { drawing = isShowingMenu } })

  sbar.exec("$CONFIG_DIR/bridge/menus/bin/menus -l", function(menus)
    local index = 0
    for menuItem in string.gmatch(menus, '[^\r\n]+') do
      index = index + 1
      if index < maxItems then
        menuItems[index]:set(
          {
            width = "dynamic",
            label = menuItem,
            drawing = true
          }
        )
      else
        break
      end
    end
  end)
end

frontAppWatcher:subscribe(constants.events.FRONT_APP_SWITCHED, updateMenus)


local function toggleMenus()
  isShowingMenu = not isShowingMenu
  updateMenus()
end

menu:subscribe(constants.events.SWAP_MENU_AND_SPACES, toggleMenus)

menu:subscribe("mouse.clicked", toggleMenus)

menu:subscribe(constants.events.AEROSPACE_SWITCH, toggleMenus)

createPlaceholders()
