_B.add({
  {
    src = "https://github.com/smjonas/inc-rename.nvim",
    confirm = false,
    data = {
      init = function(_) require("inc_rename").setup({}) end,
      keys = {
        { "<Leader>rn", ":IncRename ", { desc = "Rename Symbol" } },
      },
    },
  },
  {
    src = "https://github.com/akinsho/toggleterm.nvim",
    confirm = false,
    data = {
      init = function(_)
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
          { "<Leader>gg", function() Lazygit:toggle() end, { desc = "LazyGit" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/mrjones2014/smart-splits.nvim",
    confirm = false,
    data = {
      init = function(_) require("smart-splits").setup() end,
      keys = function()
        local SmartSplits = require("smart-splits")
        return {
          { "<C-h>", function() SmartSplits.move_cursor_left() end, { desc = "Move cursor to left window" } },
          { "<C-j>", function() SmartSplits.move_cursor_bottom() end, { desc = "Move cursor to bottom window" } },
          { "<C-k>", function() SmartSplits.move_cursor_up() end, { desc = "Move cursor to top window" } },
          { "<C-l>", function() SmartSplits.move_cursor_right() end, { desc = "Move cursor to right window" } },
          { "<A-h>", function() SmartSplits.resize_left(5) end, { desc = "Resize to left" } },
          { "<A-j>", function() SmartSplits.resize_bottom(5) end, { desc = "Resize to bottom" } },
          { "<A-k>", function() SmartSplits.resize_up(5) end, { desc = "Resize to top" } },
          { "<A-l>", function() SmartSplits.resize_right(5) end, { desc = "Resize to right" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/sindrets/diffview.nvim",
    data = {
      init = function(_)
        require("diffview").setup({
          hooks = {
            view_opened = function()
              _B.map_keys({
                { "<Leader>gh", ":DiffviewClose<CR>", { desc = "Close Diffview" } },
              })
            end,
            view_closed = function()
              _B.map_keys({
                { "<Leader>gh", ":DiffviewOpen<CR>", { desc = "Open Diffview" } },
              })
            end,
          },
        })
      end,
      keys = {
        { "<Leader>gh", ":DiffviewOpen<CR>", { desc = "Open Diffview" } },
      },
    },
  },
})
