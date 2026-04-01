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

    peazip
    pwvucontrol
    wl-clipboard
    cliphist

    ungoogled-chromium
    vial
    kdePackages.dolphin

    nerd-fonts.victor-mono
  ];

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };
}
