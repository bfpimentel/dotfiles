local add, now = MiniDeps.add, MiniDeps.now

add({
  source = "folke/noice.nvim",
  depends = { "MunifTanjim/nui.nvim" } }
)

now(function()
  local Noice = require("noice")
  Noice.setup({
    messages = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
      documentation = { enabled = false },
    },
    presets = { inc_rename = true },
    views = {
      cmdline_popup = {
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = { style = "single",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 11,
          col = "50%",
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
    },
  })
end)
