local add, now = MiniDeps.add, MiniDeps.now

add({
  source = "saghen/blink.cmp",
  depends = { "rafamadriz/friendly-snippets" },
  checkout = "v1.3.1",
})

now(function()
  local Blink = require("blink.cmp")
  Blink.setup({
    keymap = { preset = "super-tab" },
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
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },
    fuzzy = { implementation = "lua" },
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
  })
  Blink.opts_extend = { "sources.default" }
end)
