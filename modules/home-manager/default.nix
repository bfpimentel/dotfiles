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

    curl
    direnv
    fish
    git
    lazygit
    tmux
    wget

    fastfetch
    fzf
    gnupg
    libpcap
    ripgrep

    lua

    opencode
  ];
}
