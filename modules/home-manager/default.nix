{ pkgs, util, ... }:

let
  inherit (util) osSpecific;
in
{
  imports = [
    ./dotfiles.nix
    ./nvim.nix
    ./ssh.nix
  ];

  home = {
    username = "bruno";
    stateVersion = "25.11";
    homeDirectory = osSpecific {
      darwin = "/Users/bruno";
      linux = "/home/bruno";
    };
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nh

    fish
    tmux
    jq

    lua

    direnv

    lazygit
    gnupg
    ripgrep
    libpcap
    fzf
    wget

    opencode
  ];
}
