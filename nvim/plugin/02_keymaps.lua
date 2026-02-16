Util.map_keys({
  -- stylua: ignore start
  -- General
  { "<Leader>rr", "<CMD>restart<CR>", opts = {} },
  { "<S-u>",      "<C-r><CR>", opts = {} },
  { "<Esc>",      "<CMD>nohlsearch<CR><CR>", opts = {} },
  { "p",          "P", mode = "x", opts = { silent = true } },
  -- stylua: ignore end
})
