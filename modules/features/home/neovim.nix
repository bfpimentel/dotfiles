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

          typescript
          typescript-language-server
          vscode-langservers-extracted
          tailwindcss-language-server
          prettier
          oxfmt
          oxlint

          basedpyright
          ruff

          dart
        ];
      }
    )
  ];
}
