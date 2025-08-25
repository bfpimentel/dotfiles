vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/L3MON4D3/luasnip" },
  { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
})

local ColorfulMenu = require("colorful-menu")

require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
  snippets = { preset = "luasnip" },
  keymap = { preset = "super-tab" },
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
})
