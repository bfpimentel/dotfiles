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

    bitwarden-cli

    sway
    waybar
    wofi
    mako
    swaylock-effects
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    slurp
    libnotify

    pwvucontrol
    wl-clipboard
    cliphist

    brave

    nerd-fonts.victor-mono
  ];
}
