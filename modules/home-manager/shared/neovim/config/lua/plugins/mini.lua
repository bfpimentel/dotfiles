local now = MiniDeps.now

now(function()
  require("mini.ai").setup()
  require("mini.surround").setup()
  require("mini.pairs").setup()
  require("mini.diff").setup()
  require("mini.bracketed").setup()
  require("mini.tabline").setup()
end)

-- now(function()
--   local MiniBase16 = require("mini.base16")
--
--   MiniBase16.setup({
--     palette = {
--       base00 = "#32302f",
--       base01 = "#3c3836",
--       base02 = "#5a524c",
--       base03 = "#7c6f64",
--       base04 = "#bdae93",
--       base05 = "#ddc7a1",
--       base06 = "#ebdbb2",
--       base07 = "#fbf1c7",
--       base08 = "#ea6962",
--       base09 = "#e78a4e",
--       base0A = "#d8a657",
--       base0B = "#a9b665",
--       base0C = "#89b482",
--       base0D = "#7daea3",
--       base0E = "#d3869b",
--       base0F = "#bd6f3e",
--     },
--     plugins = {
--       default = false,
--       ["echasnovski/mini.files"] = true,
--       ["OXY2DEV/markview.nvim"] = true,
--     },
--   })
-- end)

now(function()
  local MiniIcons = require("mini.icons")
  MiniIcons.setup()

  package.preload["nvim-web-devicons"] = function()
    MiniIcons.mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end
end)

now(function()
  local MiniFiles = require("mini.files")
  MiniFiles.setup()

  vim.keymap.set("n", "<leader>e", function()
    local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    vim.defer_fn(function() MiniFiles.reveal_cwd() end, 30)
  end, { desc = "File Explorer" })
end)

now(function()
  local MiniStatusline = require("mini.statusline")

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
      { hl = mode_hl, strings = { search ~= "" and " " .. search, " " .. location } },
    })
  end

  MiniStatusline.setup({
    content = {
      active = groups,
      inactive = nil,
    },
  })
end)

now(function()
  local MiniClue = require("mini.clue")

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
end)

now(function()
  local MiniHipatterns = require("mini.hipatterns")

  local extmark_opts_inline = function(_, _, data)
    return {
      virt_text = { { " ", data.hl_group } },
      virt_text_pos = "inline",
      priority = 200,
      right_gravity = false,
    }
  end

  -- "0xEACDTE"
  -- #00EACDTE
  local argb_color = function(_, match)
    if string.len(match) ~= 10 then
      return false
    else
      local hex = string.format("#%s", match:sub(5, 10))
      return MiniHipatterns.compute_hex_color_group(hex, "fg")
    end
  end

  MiniHipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      hex_color = MiniHipatterns.gen_highlighter.hex_color({ style = "inline", inline_text = " " }),
      argb_color = {
        pattern = "0x%x+",
        group = argb_color,
        extmark_opts = extmark_opts_inline,
      },
    },
  })
end)
