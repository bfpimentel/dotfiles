return {
  {
    "tpope/vim-sleuth",
    lazy = false,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",     -- only load on lua files
    opts = {
      library = {
        "lazy.nvim",
        { path = "LazyVim",            words = { "LazyVim" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  }
}
