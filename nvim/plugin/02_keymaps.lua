_B.util.map_keys({
  -- stylua: ignore start
  -- General
  { "<Leader>rr", "<CMD>restart<CR>" },
  { "<S-u>",      "<C-r><CR>" },
  { "<Esc>",      "<CMD>nohlsearch<CR><CR>" },
  { "p",          "P", mode = "x", opts = { silent = true } },
  -- stylua: ignore end
})
