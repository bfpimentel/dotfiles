---@class ChadrcConfig
local M = {}

M.base46 = {
  theme = "tokyonight",
  transparency = true,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.term = {
  float = {
    row = 0.1,
    col = 0.1,
    width = 0.8,
    height = 0.7,
    border = "single",
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  }
}

return M
