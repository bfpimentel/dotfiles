{ pkgs, util, ... }:

let
  inherit (util) mapAbsolute mapDotfiles osSpecific;
in
{
  imports = [
    ./neovim.nix
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

  home.file = {
    "Documents/Vial".source = mapAbsolute "misc/vial";
    "Documents/Wallpapers".source = mapAbsolute "misc/wallpapers";
  }
  // mapDotfiles ([
    "fish"
    "git"
    "kitty"
    "lazygit"
    "nvim"
    "opencode"
    "tmux"
  ]);

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
