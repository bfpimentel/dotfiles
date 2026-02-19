Util.map_keys({
  -- stylua: ignore start
  { "<S-u>", "<C-r><CR>" },
  { "<Esc>", "<CMD>nohlsearch<CR><CR>" },
  { "p",     "P", mode = "x" },

  { "<leader>rr", "<CMD>restart<CR>" },
  { "<leader>gg", "<CMD>terminal lazygit<CR>", opts = { desc = "Open Lazygit" } },

  { "<leader>pu", function() vim.pack.update() end, opts = { desc = "Open vim.pack updates buffer" } },
  -- stylua: ignore end
})
