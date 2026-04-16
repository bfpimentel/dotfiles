{ pkgs, lib, ... }:

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

  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
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
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_IE.UTF-8";
    supportedLocales = [
      "en_IE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_CTYPE = lib.mkDefault "pt_BR.UTF-8";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_IM_MODULE = lib.mkDefault "cedilla";
    QT_IM_MODULE = lib.mkDefault "cedilla";
  };
}
