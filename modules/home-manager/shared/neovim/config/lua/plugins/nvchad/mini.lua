return {
  {
    "echasnovski/mini.surround",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.icons",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.files",
    lazy = false,
    version = false,
    -- opts = {},
    config = function()
      require('mini.files').setup()
    end,
  },
}
