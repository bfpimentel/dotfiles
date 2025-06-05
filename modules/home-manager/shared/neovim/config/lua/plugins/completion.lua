return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab", },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },
    cmdline = {
      enabled = true,
      completion = { menu = { auto_show = true } },
    },
    signature = {
      enabled = true,
    },
    completion = {
      keyword = { range = "full" },
      ghost_text = { enabled = true },
      documentation = { auto_show = true, auto_show_delay_ms = 1000 },
      menu = {
        draw = {
          columns = {
            { "label",     "label_description", gap = 1 },
            { "kind_icon", "kind" }
          }
        }
      }
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning"
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
