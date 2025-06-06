local blink = require("blink.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

--- @type vim.lsp.Config
return {
  dependencies = { "esmuellert/nvim-eslint" },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript.tsx",
    "typescriptreact",
    "typescriptreact",
  },
  root_markers = {
    ".git",
    "jsconfig.json",
    "package.json",
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
  on_attach = function() vim.lsp.start({ "nvim-eslint" }) end,
}
