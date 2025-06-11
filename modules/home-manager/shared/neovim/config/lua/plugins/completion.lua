local add, now = MiniDeps.add, MiniDeps.now

add({ source = "rafamadriz/friendly-snippets" })
add({ source = "L3MON4D3/LuaSnip" })
add({ source = "xzbdmw/colorful-menu.nvim" })

now(function()
  local ColorfulMenu = require("colorful-menu")

  local Blink = require("blink.cmp")
  Blink.setup({
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
              text = function(ctx) return ColorfulMenu.blink_components_text(ctx) end,
              highlight = function(ctx) return ColorfulMenu.blink_components_highlight(ctx) end,
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
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  })
  -- Blink.opts_extend = { "sources.default" }

  require("luasnip.loaders.from_vscode").lazy_load()
end)
