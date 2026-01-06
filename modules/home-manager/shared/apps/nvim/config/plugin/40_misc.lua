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
          { "<C-h>", SmartSplits.move_cursor_left, { desc = "Move Cursor to Left Window" } },
          { "<C-j>", SmartSplits.move_cursor_bottom, { desc = "Move Cursor to Bottom Window" } },
          { "<C-k>", SmartSplits.move_cursor_up, { desc = "Move Cursor to Top Window" } },
          { "<C-l>", SmartSplits.move_cursor_right, { desc = "Move Cursor to Right Window" } },
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
