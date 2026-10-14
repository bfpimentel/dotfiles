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
          package =
            if pkgs.stdenv.hostPlatform.isDarwin then
              inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default
            else
              pkgs.neovim-unwrapped;
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
