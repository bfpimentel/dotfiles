{ pkgs, ... }:

{
  imports = [
    ./gaming.nix
  ];

  home.packages = with pkgs; [
    kitty

    bitwarden-cli
    openclaw

    nodejs_25

    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprpwcenter

    cliphist
    grim
    libnotify
    playerctl
    quickshell
    satty
    slurp
    wl-clipboard

    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    appimage-run
    gearlever
    peazip
    ungoogled-chromium
    vial

    podman
    podman-compose

    kdePackages.dolphin

    qt6.qtbase
    qt6.qtdeclarative # qmlls
    qt6.qttools

    hanken-grotesk
    nerd-fonts.symbols-only
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
