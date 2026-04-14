{ pkgs, ... }:

{
  imports = [
    ./gaming.nix
  ];

  home.file.".XCompose".text = ''
    include "%L"

    <dead_acute> <C> : "Ç"
    <dead_acute> <c> : "ç"
  '';

  home.sessionVariables = {
    GTK_IM_MODULE = "cedilla";
    QT_IM_MODULE = "cedilla";
  };

  home.packages = with pkgs; [
    git
    kitty

    jq

    fastfetch

    python3
    typescript-go
    basedpyright
    nodejs_25

    qt6.qtbase
    qt6.qttools
    qt6.qtdeclarative # qmlls

    bitwarden-cli

    hyprland
    hypridle
    hyprlock
    hyprpaper
    hyprpwcenter

    quickshell
    slurp
    grim
    satty
    libnotify
    cliphist
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    ungoogled-chromium
    vial
    peazip
    gearlever
    appimage-run

    podman
    podman-compose

    kdePackages.dolphin

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
