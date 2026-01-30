--- @type vim.lsp.Config
return {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = {
    "flake.nix",
    ".git",
  },
  single_file_support = true,
  settings = {
    ["nil"] = {
      flake = {
        autoEvalInputs = true,
      },
    },
  },
}
