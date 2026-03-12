--- @type vim.lsp.Config
return {
  -- cmd = { "ty", "server" },
  cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
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
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
      },
    },
    -- ty = {},
    python = {
      pythonPath = ".venv/bin/python",
    },
  },
  handlers = {
    ["$/progress"] = function(err, result, ctx)
      if result.token == (vim.g.basedpyright_progress_token or result.token) then
        vim.g.basedpyright_progress_token = result.token
        vim.lsp.handlers["$/progress"](err, result, ctx)
      end
    end,
  },
}
