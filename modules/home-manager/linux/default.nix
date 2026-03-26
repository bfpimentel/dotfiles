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

    pwvucontrol
    wl-clipboard
    cliphist

    brave

    steam

    nerd-fonts.victor-mono
  ];
}
