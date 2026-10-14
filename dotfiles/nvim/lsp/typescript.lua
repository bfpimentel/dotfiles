--- @type vim.lsp.Config
return {
  cmd = { "tsc", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
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
