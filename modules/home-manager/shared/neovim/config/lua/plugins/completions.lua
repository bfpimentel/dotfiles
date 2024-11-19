return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    nerd_font_variant = "normal",
    opts_extend = { "sources.completion.enabled_providers" },
    trigger = { signature_help = { enabled = true } },
    keymap = { preset = "super-tab", },
    -- keymap = {
    --   show = "<C-CR>",
    --   show_documentation = "<C-CR>",
    --   hide_documentation = "<C-CR>",
    -- },
    windows = {
      documentation = {
        min_width = 15,
        max_width = 50,
        max_height = 15,
        auto_show = true,
        border = "single",
        auto_show_delay_ms = 200,
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
      },
      autocomplete = {
        min_width = 25,
        border = "single",
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
        cycle = { from_bottom = true, from_top = false },
        draw = function(ctx)
          local iconHl = vim.g.colors_name:find("tokyonight") and "BlinkCmpKind" or "BlinkCmpKind" .. ctx.kind

          return {
            " ",
            {
              ctx.item.label,
              fill = true,
              max_width = 50,
            },
            " ",
            { ctx.kind_icon, hl_group = iconHl },
            " ",
          }
        end,
      },
    },
    kind_icons = {
      Text = "󰦨",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "⬟",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "󰒕",
      Color = "󰏘",
      Reference = "",
      File = "󰉋",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    },
  },
}
