{ pkgs, ... }:

{
  imports = [
    ./gaming.nix
  ];

  home.packages = with pkgs; [
    git
    kitty

    sway
    waybar
    wofi

    wl-clipboard
    cliphist

    brave

    steam

    nerd-fonts.victor-mono
  ];
}
