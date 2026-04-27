{ ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      {
        pkgs,
        util,
        ...
      }:
      let
        inherit (util) mapAbsolute mapDotfiles osSpecific;

        zshEnv = /* zsh */ ''
          export XDG_CONFIG_HOME="$HOME/.config"
          export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
        '';
      in
      {
        home = {
          username = "bruno";
          stateVersion = "25.11";
          homeDirectory = osSpecific {
            darwin = "/Users/bruno";
            linux = "/home/bruno";
          };
        };

        programs.home-manager.enable = true;

        home.file = {
          "Documents/Vial".source = mapAbsolute "misc/vial";
          "Documents/Wallpapers".source = mapAbsolute "misc/wallpapers";
          ".zshenv".text = zshEnv;
        }
        // mapDotfiles ([
          "git"
          "kitty"
          "lazygit"
          "nvim"
          "opencode"
          "tmux"
          "zsh"
        ]);

        home.packages = with pkgs; [
          nh

          antidote
          oh-my-posh

          curl
          git
          lazygit
          tmux
          wget
          uv

          fastfetch
          fzf
          gnupg
          libpcap
          ripgrep

          lua

          opencode
        ];
      }
    )
  ];
}
