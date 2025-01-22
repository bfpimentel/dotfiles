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
    signature = {
      enabled = true,
    },
    sources = {
      default = { "lsp", "lazydev", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
        },
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
