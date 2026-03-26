{ pkgs, ... }:

{
  imports = [
    ./gaming.nix
  ];

  home.packages = with pkgs; [
    git
    kitty

    fastfetch
    python3

    sway
    waybar
    wofi
    mako
    swaylock-effects
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    slurp

    pwvucontrol
    wl-clipboard
    cliphist

    brave

    steam

    nerd-fonts.victor-mono
  ];
}
