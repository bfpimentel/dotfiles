--- @type vim.lsp.Config
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_markers = { ".git" },
  single_file_support = true,
}
