return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab", },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },
  },
  opts_extend = { "sources.default" },
}
