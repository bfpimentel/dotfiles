local P = require("utils.pack")

P.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
    data = {
      init = function(_)
        require("nvim-treesitter").setup()
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
            "query",
            "elixir",
            "heex",
            "html",
            "javascript",
            "typescript",
            "python",
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
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = { query = "@function.outer", desc = "around a function" },
                ["if"] = { query = "@function.inner", desc = "inner part of a function" },
                ["ac"] = { query = "@class.outer", desc = "around a class" },
                ["ic"] = { query = "@class.inner", desc = "inner part of a class" },
                ["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
                ["ii"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
                ["al"] = { query = "@loop.outer", desc = "around a loop" },
                ["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
                ["ap"] = { query = "@parameter.outer", desc = "around parameter" },
                ["ip"] = { query = "@parameter.inner", desc = "inside a parameter" },
              },
              selection_modes = {
                ["@parameter.outer"] = "v", -- charwise
                ["@parameter.inner"] = "v", -- charwise
                ["@function.outer"] = "v", -- charwise
                ["@conditional.outer"] = "V", -- linewise
                ["@loop.outer"] = "V", -- linewise
                ["@class.outer"] = "<C-v>", -- blockwise
              },
              include_surrounding_whitespace = false,
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_previous_start = {
                ["[f"] = { query = "@function.outer", desc = "Previous function" },
                ["[c"] = { query = "@class.outer", desc = "Previous class" },
                ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
              },
              goto_next_start = {
                ["]f"] = { query = "@function.outer", desc = "Next function" },
                ["]c"] = { query = "@class.outer", desc = "Next class" },
                ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ["<Leader>a"] = "@parameter.inner",
              },
              swap_previous = {
                ["<Leader>A"] = "@parameter.inner",
              },
            },
          },
        })
      end,
    },
  },
})
