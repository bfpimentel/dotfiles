_B.map_keys({
  -- stylua: ignore start
  -- General
  { "<Leader>rr", "<CMD>restart<CR>", opts = { desc = "Restart Neovim" } },
  { "<S-u>",      "<C-r><CR>", opts = { desc = "Redo" } },
  { "<Esc>",      "<CMD>nohlsearch<CR><CR>", opts = { desc = "Clean Search " } },
  -- stylua: ignore end
})
