local constants = require("constants")
local settings = require("config.settings")

sbar.add("item", {
  width = settings.dimens.padding.label
})

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local currentSpaceWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces = {}

local spacesConfig = {
  ["X"] = { name = "Misc" },
  ["T"] = { name = "Terminal" },
  ["F"] = { name = "Files" },
  ["E"] = { name = "Mail" },
  ["C"] = { name = "Coding" },
  ["B"] = { name = "Browsing" },
}

local function selectCurrentSpace(focusedSpaceName)
  for sid, item in pairs(spaces) do
    if item ~= nil then
      local isSelected = sid == constants.items.SPACES .. "." .. focusedSpaceName
      item:set({ icon = { string = isSelected and "" or "" } })
    end
  end

  sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentSpace()
  sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedSpaceOutput)
    local focusedSpaceName = focusedSpaceOutput:match("[^\r\n]+")
    selectCurrentSpace(focusedSpaceName)
  end)
end

local function addSpace(spaceName)
  local spaceId = constants.items.SPACES .. "." .. spaceName
  local spaceConfig = spacesConfig[spaceName]

  spaces[spaceId] = sbar.add("item", spaceId, {
    background = {
      padding_right = 8,
      padding_left = 4,
    },
    label = {
      width = 0,
      string = spaceConfig.name,
    },
    icon = {
      padding_left = 0,
      font = { size = 24.0 },
      color = settings.colors.white,
    },
    click_script = "aerospace workspace " .. spaceName,
  })

  spaces[spaceId]:subscribe("mouse.entered", function()
    sbar.animate("tanh", 30, function()
      spaces[spaceId]:set({ label = { width = "dynamic", padding_left = 8 } })
    end)
  end)

  spaces[spaceId]:subscribe("mouse.exited", function()
    sbar.animate("tanh", 30, function()
      spaces[spaceId]:set({ label = { width = 0, padding_left = 0 } })
    end)
  end)
end

local function createSpaces()
  for spaceName, _ in pairs(spacesConfig) do
    addSpace(spaceName)
  end

  sbar.add("bracket", { "/" .. constants.items.SPACES .. "\\..*/" }, {
    background = {
      color = settings.colors.surface2,
      padding_right = 0,
      padding_left = 0,
      corner_radius = 8,
    },
  })

  findAndSelectCurrentSpace()
end

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  local isShowingSpaces = env.isShowingMenu == "off" and true or false
  sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

currentSpaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  selectCurrentSpace(env.FOCUSED_WORKSPACE)
  sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

createSpaces()
