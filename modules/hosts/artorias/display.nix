{ pkgs, ... }:

let
  sddm-theme-name = "sddm-bfmp";

  sddm-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = sddm-theme-name;
    version = "0.1.0";
    dontUnpack = true;

    installPhase = ''
      themeDir="$out/share/sddm/themes/${sddm-theme-name}"
      mkdir -p "$themeDir"

      install -m0644 ${./sddm-theme/Main.qml} "$themeDir/Main.qml"
      install -m0644 ${./sddm-theme/metadata.desktop} "$themeDir/metadata.desktop"
      install -m0644 ${./sddm-theme/theme.conf} "$themeDir/theme.conf"
    '';
  };
in
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = [
    pkgs.nerd-fonts.victor-mono

  ];

  environment.systemPackages = [
    sddm-theme
    pkgs.adwaita-icon-theme
  ];

  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.ly.enable = false;

  services.displayManager.defaultSession = "hyprland";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    package = pkgs.kdePackages.sddm;
    theme = sddm-theme-name;
    extraPackages = [ sddm-theme ];
    settings = {
      Theme = {
        CursorTheme = "Adwaita";
        CursorSize = 24;
      };
    };
  };
}
