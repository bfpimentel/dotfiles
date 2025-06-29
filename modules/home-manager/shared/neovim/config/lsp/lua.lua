local Blink = require("blink.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = Blink.get_lsp_capabilities(capabilities)

--- @type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
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
        version = "Lua5.4",
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      diagnostics = {
        globals = {
          "vim",
          "use",
        },
      },
    },
  },
  capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  }),
}
