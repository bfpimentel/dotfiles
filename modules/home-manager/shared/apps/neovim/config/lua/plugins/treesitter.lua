local P = require("utils.pack")

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

P.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
    data = {
      init = function(_)
        require("nvim-treesitter.configs").setup({
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
          auto_install = true,
          ensure_installed = {
            "c",
            "lua",
            "nix",
            "vim",
            "vimdoc",
            "html",
            "javascript",
            "typescript",
            "python",
            "css",
            "json",
            "yaml",
            "markdown",
            "markdown_inline",
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<Leader>vv",
              node_incremental = "<C-p>",
              node_decremental = "<C-n>",
              scope_incremental = false,
            },
          },
        })
      end,
    },
  },
})
