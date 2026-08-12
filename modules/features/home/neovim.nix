{ inputs, ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      { pkgs, ... }:
      let
        mv = inputs.multiverse.multiverse.${pkgs.stdenv.hostPlatform.system};
      in
      {
        home.packages = with pkgs; [
          neovim

          gcc
          tree-sitter

          nixd
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
          oxfmt
          (mv.version "oxlint" "1.76.0") # FIXME: 1.77.0 is not being able to compile

          basedpyright
          ruff

          dart
        ];
      }
    )
  ];
}
