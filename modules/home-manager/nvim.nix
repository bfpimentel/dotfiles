{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      stdenv.cc
      tree-sitter

      ruff

      nil
      nixfmt

      lua-language-server
      stylua

      bash-language-server
      beautysh

      yaml-language-server
      yamlfmt

      oxlint
      prettierd
      typescript-language-server
      tailwindcss-language-server
      vscode-langservers-extracted

      fish-lsp
    ];
  };
}
