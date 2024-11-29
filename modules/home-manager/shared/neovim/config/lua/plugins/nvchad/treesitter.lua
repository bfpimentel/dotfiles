return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
  opts = {
    sync_install = false,
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>",
        node_incremental = "<C-n>",
        node_decremental = "<C-r>",
        scope_incremental = "<C-s>",
      },
    },
    ensure_installed = {
      "typescript",
      "c",
      "lua",
      "nix",
      "vim",
      "vimdoc",
      "query",
      "elixir",
      "heex",
      "javascript",
      "html",
      "markdown",
      "markdown_inline"
    },
  },
}
