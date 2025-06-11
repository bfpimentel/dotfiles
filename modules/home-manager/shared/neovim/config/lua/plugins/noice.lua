local add, now = MiniDeps.add, MiniDeps.now

add({
  source = "folke/noice.nvim",
  depends = { "MunifTanjim/nui.nvim" },
})

now(function()
  if true then return end -- disabled for now

  local Noice = require("noice")
  Noice.setup({
    presets = {
      inc_rename = true,
      long_message_to_split = true,
      bottom_search = false,
    },
    cmdline = { enabled = true },
    popupmenu = { enabled = true },
    messages = { enabled = true },
    notify = { enabled = false },
    lsp = {
      message = { enabled = true },
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      documentation = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    views = {
      messages = {
        border = { style = "single" },
      },
      cmdline_popup = {
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = { style = "single" },
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
