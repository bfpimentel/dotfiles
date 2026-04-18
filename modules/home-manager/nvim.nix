{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
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
}
