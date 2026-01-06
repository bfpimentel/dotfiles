_B.map_keys({
  -- stylua: ignore start
  -- General
  { "<Leader>rr", "<CMD>restart<CR>", { desc = "Restart Neovim" } },
  { "<S-u>",      "<C-r><CR>", { desc = "Redo" } },
  { "<Esc>",      "<CMD>nohlsearch<CR><CR>", { desc = "Clean Search " } },
  -- stylua: ignore end
  {
    mode = { "i", "n" },
    "<Tab>",
    function()
      if vim.lsp.inline_completion.get() then return end
      return "<Tab>"
    end,
    { expr = true },
  },
})
