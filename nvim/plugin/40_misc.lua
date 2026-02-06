_B.add({
  {
    src = "https://github.com/smjonas/inc-rename.nvim",
    data = {
      load = function() require("inc_rename").setup({}) end,
      keys = function()
        return {
          { "<Leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/akinsho/toggleterm.nvim",
    data = {
      load = function()
        require("toggleterm").setup({
          shade_terminals = false,
        })
      end,
      keys = function()
        local Terminal = require("toggleterm.terminal").Terminal
        local Lazygit = Terminal:new({
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          float_opts = { border = "solid" },
        })

        return {
          { "<Leader>gg", function() Lazygit:toggle() end, opts = { desc = "LazyGit" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/mrjones2014/smart-splits.nvim",
    data = {
      load = function()
        require("smart-splits").setup({
          default_amount = 5,
        })
      end,
      keys = function()
        local SmartSplits = require("smart-splits")

        return {
          -- stylua: ignore start
          { "<C-h>", function() SmartSplits.move_cursor_left() end, opts = { silent = true } },
          { "<C-j>", function() SmartSplits.move_cursor_down() end, opts = { silent = true } },
          { "<C-k>", function() SmartSplits.move_cursor_up() end, opts = { silent = true } },
          { "<C-l>", function() SmartSplits.move_cursor_right() end, opts = { silent = true } },
          { "<A-h>", function() SmartSplits.resize_left() end, opts = { silent = true } },
          { "<A-j>", function() SmartSplits.resize_down() end, opts = { silent = true } },
          { "<A-k>", function() SmartSplits.resize_up() end, opts = { silent = true } },
          { "<A-l>", function() SmartSplits.resize_right() end, opts = { silent = true } },
          -- stylua: ignore end
        }
      end,
    },
  },
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    data = {
      load = function() require("render-markdown").setup({}) end,
      keys = function()
        return {
          { "<Leader>rm", ":RenderMarkdown toggle<CR>", opts = { desc = "Render Markdown" } },
        }
      end,
    },
  },
})
