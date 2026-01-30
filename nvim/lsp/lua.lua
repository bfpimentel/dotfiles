--- @type vim.lsp.Config
return {
  cmd = { "emmylua_ls" },
  filetypes = { "lua" },
  root_markers = {
    ".git",
    ".luacheckrc",
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "selene.toml",
    "selene.yml",
    "stylua.toml",
  },
  single_file_support = true,
  telemetry = { enabled = false },
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.4",
        path = {
          "?.lua",
          "?/init.lua",
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = {
        globals = {
          "vim",
          "use",
        },
      },
    },
  },
}
