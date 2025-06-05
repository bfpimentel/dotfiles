local blink = require("blink.cmp")

--- @type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript",
    "typescript.tsx",
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
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities(),
    {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    }
  ),
}
