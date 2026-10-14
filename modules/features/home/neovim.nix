{ inputs, ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      { lib, pkgs, ... }:
      let
        mv = inputs.multiverse.multiverse.${pkgs.stdenv.hostPlatform.system};
      in
      {
        programs.neovim = {
          enable = true;
          package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
          withPython3 = false;
          withRuby = false;

          extraPackages = with pkgs; [
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
            # typescript-language-server
            vscode-langservers-extracted
            tailwindcss-language-server
            prettier
            oxfmt
            oxlint

            basedpyright
            ruff

            dart
          ];
        };

        xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
      }
    )
  ];
}
