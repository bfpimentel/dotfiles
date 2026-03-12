Pack.later(function()
  Pack.add({ "https://github.com/mrjones2014/smart-splits.nvim" })

  local SmartSplits = require("smart-splits")

  SmartSplits.setup({
    default_amount = 5,
  })

  Util.map_keys({
    -- stylua: ignore start
    { "<C-h>", function() SmartSplits.move_cursor_left() end },
    { "<C-j>", function() SmartSplits.move_cursor_down() end },
    { "<C-k>", function() SmartSplits.move_cursor_up() end },
    { "<C-l>", function() SmartSplits.move_cursor_right() end },
    { "<A-h>", function() SmartSplits.resize_left() end },
    { "<A-j>", function() SmartSplits.resize_down() end },
    { "<A-k>", function() SmartSplits.resize_up() end },
    { "<A-l>", function() SmartSplits.resize_right() end },
    -- stylua: ignore end
  }, { silent = true })
end)

Pack.later(function()
  Pack.add({ "https://github.com/smjonas/inc-rename.nvim" })

  require("inc_rename").setup({})

  Util.map_keys({
    { "<leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
  })
end)

Pack.on_filetype("markdown", function()
  Pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

  require("render-markdown").setup({})

  Util.map_keys({
    { "<leader>rm", ":RenderMarkdown toggle<CR>", opts = { desc = "Render Markdown" } },
  })
end)

Pack.later(function()
  Pack.add({ "https://github.com/stevearc/quicker.nvim" })

  local Quicker = require("quicker")

  Quicker.setup()

  Util.map_keys({
    { "<leader>q", function() Quicker.toggle({ loclist = true }) end, opts = { desc = "Toggle Loclist" } },
  })
end)
