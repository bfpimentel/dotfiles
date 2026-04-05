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

    bitwarden-cli

    sway
    waybar
    wofi
    mako
    swaylock-effects
    swayidle
    slurp
    grim
    satty
    libnotify
    pwvucontrol
    cliphist
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr

    ungoogled-chromium
    vial
    peazip
    gearlever
    appimage-run

    podman
    podman-compose

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
