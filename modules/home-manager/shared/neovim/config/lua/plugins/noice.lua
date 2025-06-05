return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
  opts = {
    messages = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
      documentation = { enabled = false },
    },
    presets = {
      inc_rename = true,
    },
    views = {
      cmdline_popup = {
        position = {
          row = 8,
          col = "50%"
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "single",
        }
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 11,
          col = "50%"
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "single",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    }
  },
}
