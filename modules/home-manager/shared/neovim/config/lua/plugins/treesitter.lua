local add, now = MiniDeps.add, MiniDeps.now

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})

now(function()
  local Treesitter = require("nvim-treesitter.configs")
  Treesitter.setup({
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
