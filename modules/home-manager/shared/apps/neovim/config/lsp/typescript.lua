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
}
