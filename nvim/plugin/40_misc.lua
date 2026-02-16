_B.pack.now(function()
  _B.pack.add({ { src = "https://github.com/smjonas/inc-rename.nvim" } })

  require("inc_rename").setup({})

  _B.util.map_keys({
    { "<Leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
  })
end)

_B.pack.now(function()
  _B.pack.add({ { src = "https://github.com/akinsho/toggleterm.nvim" } })

  require("toggleterm").setup({
    shade_terminals = false,
  })

  local Terminal = require("toggleterm.terminal").Terminal
  local Lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = { border = "solid" },
  })

  _B.util.map_keys({
    { "<Leader>gg", function() Lazygit:toggle() end, opts = { desc = "LazyGit" } },
  })
end)

_B.pack.now(function()
  _B.pack.add({ { src = "https://github.com/mrjones2014/smart-splits.nvim" } })

  local SmartSplits = require("smart-splits")

  ---@diagnostic disable-next-line: missing-fields, param-type-mismatch
  SmartSplits.setup({
    default_amount = 5,
  })

  _B.util.map_keys({
    -- stylua: ignore start
    { "<C-h>", function() SmartSplits.move_cursor_left() end,   opts = { silent = true } },
    { "<C-j>", function() SmartSplits.move_cursor_down() end,   opts = { silent = true } },
    { "<C-k>", function() SmartSplits.move_cursor_up() end,     opts = { silent = true } },
    { "<C-l>", function() SmartSplits.move_cursor_right() end,  opts = { silent = true } },
    { "<A-h>", function() SmartSplits.resize_left() end,        opts = { silent = true } },
    { "<A-j>", function() SmartSplits.resize_down() end,        opts = { silent = true } },
    { "<A-k>", function() SmartSplits.resize_up() end,          opts = { silent = true } },
    { "<A-l>", function() SmartSplits.resize_right() end,       opts = { silent = true } },
    -- stylua: ignore end
  })
end)

_B.pack.now(function()
  _B.pack.add({ { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" } })

  require("render-markdown").setup({})

  _B.util.map_keys({
    { "<Leader>rm", ":RenderMarkdown toggle<CR>", opts = { desc = "Render Markdown" } },
  })
end)
