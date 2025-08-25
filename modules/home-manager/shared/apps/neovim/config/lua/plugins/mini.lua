local K = require("utils.keys")

vim.pack.add({ { src = "https://github.com/echasnovski/mini.nvim", version = nil } })

require("mini.ai").setup()
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.bracketed").setup()
require("mini.visits").setup()

local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
local MiniNotify = require("mini.notify")
local MiniFiles = require("mini.files")
local MiniDiff = require("mini.diff")
local MiniClue = require("mini.clue")
local MiniStatusline = require("mini.statusline")
local MiniHipatterns = require("mini.hipatterns")
local MiniAnimate = require("mini.animate")
local MiniIndentScope = require("mini.indentscope")
local Mini2D = require("mini.jump2d")

vim.ui.select = MiniPick.ui_select

MiniDiff.setup()

MiniAnimate.setup({
  cursor = {
    timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
  },
  scroll = {
    timing = MiniAnimate.gen_timing.linear({ duration = 100, unit = "total" }),
  },
})

MiniFiles.setup({
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 40,
    width_nofocus = 20,
    width_preview = 50,
  },
})

MiniIndentScope.setup({
  symbol = "│",
})

Mini2D.setup({
  view = {
    dim = true,
  },
  allowed_windows = {
    current = true,
    not_current = false,
  },
})

local zero_x_colors = function(_, match)
  local len = string.len(match)
  if len == 8 or len == 10 then
    local start = len == 8 and 3 or 5
    local eend = len == 8 and 8 or 10
    local hex = string.format("#%s", match:sub(start, eend))
    return MiniHipatterns.compute_hex_color_group(hex, "bg")
  end

  return false
end

local hex_colors = function(_, match)
  local len = string.len(match)
  if len == 7 or len == 9 then
    local hex = string.format("#%s", match:sub(2, 7))
    return MiniHipatterns.compute_hex_color_group(hex, "bg")
  end

  return false
end

MiniHipatterns.setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    zero_x_colors = {
      pattern = "0x%x+",
      group = zero_x_colors,
    },
    hex_colors = {
      pattern = "#%x+",
      group = hex_colors,
    },
  },
})

MiniClue.setup({
  clues = {
    MiniClue.gen_clues.g(),
    MiniClue.gen_clues.windows(),
  },
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<leader>" },
    { mode = "x", keys = "<leader>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },
  },
})

local check_macro_recording = function()
  if vim.fn.reg_recording() ~= "" then
    return "Recording @" .. vim.fn.reg_recording()
  else
    return ""
  end
end

-- Add it to MiniStatusline.combine_group
local function groups()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  local git = MiniStatusline.section_git({ trunc_width = 40 })
  local diff = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
  local filename = vim.fn.expand("%:t")
  local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  local location = MiniStatusline.section_location({ trunc_width = 75 })
  local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

  return MiniStatusline.combine_groups({
    { hl = mode_hl, strings = { mode } },
    { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
    "%<", -- Mark general truncate point
    { hl = "MiniStatuslineFilename", strings = { filename } },
    "%=", -- End left alignment
    { hl = "MiniStatuslineModeReplace", strings = { check_macro_recording() } },
    { hl = "MiniStatuslineFilename", strings = { fileinfo } },
    { hl = mode_hl, strings = search ~= "" and { " " .. search } },
    { hl = "MiniStatuslineModeReplace", strings = { location } },
  })
end

MiniStatusline.setup({
  content = {
    active = groups,
    inactive = nil,
  },
})

local function toggle_files()
  local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
end

-- stylua: ignore start
K.map(",", function() MiniPick.builtin.buffers() end, { desc = "Buffers" })
K.map("/", function() MiniPick.builtin.grep_live() end, { desc = "Grep" })
K.map("hc", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "Commands History" })
K.map("hs", function() MiniExtra.pickers.history({ scope = "/" }) end, { desc = "Commands History" })
K.map("hn", function() MiniNotify.show_history() end, { desc = "Notification History" })
K.map("fc", function() MiniPick.builtin.files({ source = { cwd = vim.fn.stdpath("config") } }) end, { desc = "Find Config File" })
K.map("fp", function() MiniPick.builtin.files() end, { desc = "Find Files" })
K.map("fr", function() MiniExtra.pickers.visit_paths({ recency_weight = 1 }) end, { desc = "Recent" })
K.map("sh", function() MiniPick.builtin.help() end, { desc = "Help Pages" })
K.map('s"', function() MiniExtra.pickers.registers() end, { desc = "Registers" })
K.map("sb", function() MiniExtra.pickers.buf_lines() end, { desc = "Buffer Lines" })
K.map("sc", function() MiniExtra.pickers.commands() end, { desc = "Commands" })
K.map("sd", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics" })
K.map("sD", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, { desc = "Buffer Diagnostics" })
K.map("sH", function() MiniExtra.pickers.hl_groups() end, { desc = "Highlight Groups" })
K.map("sk", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
K.map("sm", function() MiniExtra.pickers.marks() end, { desc = "Marks" })
K.map("sC", function() MiniExtra.pickers.colorschemes() end, { desc = "Colorschemes" })
K.map("gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, { desc = "Declarations" })
K.map("gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, { desc = "Definitions" })
K.map("gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, { desc = "References", nowait = true })
K.map("gI", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, { desc = "Implementation" })
K.map("gy", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, { desc = "Type Definition" })
K.map("gs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, { desc = "Symbols" })
K.map("gS", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, { desc = "Workspace Symbols" })

K.map("gh", MiniDiff.toggle_overlay, { desc = "Toggle Diff Overlay" })
K.map("e", toggle_files, { desc = "File Explorer" })
-- stylua: ignore end
