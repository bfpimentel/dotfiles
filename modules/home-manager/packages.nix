{ pkgs, util, ... }:

let
  inherit (util) osSpecific;
in

{
  home.packages =
    with pkgs;
    [
      nh

      fish
      tmux

      lua

      direnv

      lazygit
      gnupg
      ripgrep
      libpcap
      fzf
      wget

      opencode
    ]
    ++ (osSpecific {
      darwin = [ ];
      linux = [
        git
        kitty

        sway
        waybar
        wofi

        brave
      ];
    });
}
