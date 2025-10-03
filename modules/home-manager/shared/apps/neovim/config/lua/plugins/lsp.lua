local P = require("utils.pack")

P.add({
  { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("v1.*"),
    data = {
      init = function(_)
        local ColorfulMenu = require("colorful-menu")

        require("blink.cmp").setup({
          appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "normal",
          },
          cmdline = {
            enabled = true,
            completion = { menu = { auto_show = true } },
          },
          signature = {
            enabled = true,
            window = {
              border = nil,
            },
          },
          completion = {
            keyword = { range = "full" },
            ghost_text = { enabled = true },
            documentation = {
              auto_show = true,
              auto_show_delay_ms = 1000,
            },
            menu = {
              draw = {
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                  label = {
                    text = ColorfulMenu.blink_components_text,
                    highlight = ColorfulMenu.blink_components_highlight,
                  },
                },
              },
            },
            accept = {
              auto_brackets = { enabled = false },
            },
          },
          fuzzy = { implementation = "prefer_rust_with_warning" },
          sources = {
            default = { "lsp", "path", "buffer", "snippets" },
          },
          keymap = {
            preset = "enter",
            ["<Tab>"] = {
              "snippet_forward",
              function() return require("sidekick").nes_jump_or_apply() end,
              function() return vim.lsp.inline_completion.get() end,
              "fallback",
            },
          },
        })
      end,
    },
  },
  {
    src = "https://github.com/stevearc/conform.nvim",
    data = {
      lazy = { keys = { "<Leader>ff" } },
      init = function(_)
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            yaml = { "yamlfmt" },
            nix = { "nixfmt" },
            python = { "ruff_format" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
          },
          -- prettier = {
          --   require_cwd = true,
          --   prepend_args = { "--print-width=120" },
          -- },
        })
      end,
      keys = function()
        local function format() require("conform").format({ lsp_fallback = true }) end

        return {
          { "<Leader>ff", format, opts = { desc = "Format File" } },
        }
      end,
    },
  },
})
