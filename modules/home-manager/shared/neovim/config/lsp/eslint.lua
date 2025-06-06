local blink = require("blink.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

--- @type vim.lsp.Config
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  root_markers = {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
  },
  settings = {
    packageManager = "npm",
    useFlatConfig = true,
  },
  capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  }),
}
