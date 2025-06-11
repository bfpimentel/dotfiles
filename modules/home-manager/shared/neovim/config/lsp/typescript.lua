local blink = require("blink.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

--- @type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    ".git",
    "package.json",
    "jsconfig.json",
    "tsconfig.json",
  },
  init_options = { hostInfo = "neovim" },
  single_file_support = true,
  capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  }),
}
