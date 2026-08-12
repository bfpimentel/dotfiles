--- @type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = {
    "flake.nix",
    ".git",
  },
  single_file_support = true,
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.powers.options",
        },
        darwin = {
          expr = "(builtins.getFlake (builtins.toString ./.)).darwinConfigurations.seraphim.options",
        },
        home_manager = {
          expr = '(builtins.getFlake (builtins.toString ./.)).homeConfigurations."bruno@seraphim".options',
        },
      },
    },
  },
}
