--- @type vim.lsp.Config
return {
  cmd = { "xcrun", "sourcekit-lsp" },
  filetypes = { "swift" },
  root_markers = {
    "buildServer.json",
    "Package.swift",
    ".git",
  },
}
