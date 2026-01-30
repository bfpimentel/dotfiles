--- @type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    -- basedpyright = {
    --   analysis = {
    --     autoSearchPaths = true,
    --     useLibraryCodeForTypes = true,
    --     diagnosticMode = "openFilesOnly",
    --     typeCheckingMode = "off",
    --   },
    -- },
    ty = {
      -- configuration = {
      --   rules = {},
      -- },
    },
    python = {
      pythonPath = ".venv/bin/python",
    },
  },
}
