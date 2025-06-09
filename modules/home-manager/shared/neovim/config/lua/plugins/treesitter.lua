local add, later = MiniDeps.add, MiniDeps.later

add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})

later(function()
  require("nvim-treesitter").setup({
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
      "c",
      "lua",
      "nix",
      "vim",
      "vimdoc",
      "query",
      "elixir",
      "heex",
      "html",
      "javascript",
      "typescript",
      "markdown",
      "markdown_inline",
    },
  })
end)
