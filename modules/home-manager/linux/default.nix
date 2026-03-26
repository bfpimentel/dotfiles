{ pkgs, ... }:

{
  imports = [
    ./gaming.nix
  ];

  home.packages = with pkgs; [
    git
    kitty

    fastfetch

    sway
    waybar
    wofi
    mako
    swaylock-effects

    pwvucontrol
    wl-clipboard
    cliphist

    brave

    steam

    nerd-fonts.victor-mono
  ];
}
