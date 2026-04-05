{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    extraPackages = with pkgs; [
      nil
      nixfmt

      lua-language-server
      stylua

      bash-language-server
      beautysh

      yaml-language-server
      yamlfmt

      prettier
      # typescript-go # does not work here but works globally
      typescript-language-server
      vscode-langservers-extracted
      tailwindcss-language-server

      # basedpyright # does not work here but works globally
      ruff

      fish-lsp

      dart
    ];
  };
}
