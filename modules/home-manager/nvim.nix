{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = true;
    # withPython3 = true;
    extraWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath (
        with pkgs;
        [
          gcc
          tree-sitter
          typescript-go
          basedpyright
        ]
      )}"
    ];
    extraPackages = with pkgs; [
      gcc
      tree-sitter

      # Language servers and linters
      nil
      nixfmt

      lua-language-server
      stylua

      bash-language-server
      beautysh

      yaml-language-server
      yamlfmt

      typescript-go
      typescript-language-server
      vscode-langservers-extracted
      tailwindcss-language-server
      prettier

      basedpyright
      ruff

      fish-lsp

      dart
    ];
  };
}
