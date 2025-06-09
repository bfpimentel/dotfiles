local blink = require("blink.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

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
        version = "Lua 5.4",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      diagnostics = {
        disable = { "missing-parameters", "missing-fields" },
        globals = {
          "vim",
          "use",
        },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
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
