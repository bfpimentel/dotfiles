{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.xserver;
in
{
  options.bfmp.services.xserver = {
    enable = mkEnableOption "Enable X11 Server";
    configureForSunshine = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to configure X11 Server for Headless Sunshine Server";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver.videoDrivers = [ "nvidia" ];
    })
    (mkIf cfg.configureForSunshine {
      environment.systemPackages = with pkgs; [
        xorg.xrandr
      ];

      security.rtkit.enable = true;

      services.xserver = {
        xkb = {
          layout = "en";
          variant = "qwerty";
        };

        desktopManager.gnome.enable = true;

        displayManager.gdm = {
          enable = true;
          autoSuspend = false;
        };

        deviceSection = ''
          VendorName      "NVIDIA Corporation"
          Option          "AllowEmptyInitialConfiguration"
          Option          "ConnectedMonitor" "DFP"
          Option          "CustomEDID" "DFP-0"
        '';

        monitorSection = ''
          Identifier      "Configured Monitor"
          HorizSync       30-85
          VertRefresh     48-120
        '';

        screenSection = ''
          Identifier      "Default Screen"
          DefaultDepth    24
          Option          "ModeValidation" "AllowNonEdidModes, NoVesaModes"
          Option          "MetaModes" "1920x1080"
          SubSection      "Display"
              Depth       24
              Modes       "1920x1080"
          EndSubSection
        '';
      };

      services.displayManager = {
        defaultSession = "gnome";
        autoLogin = {
          enable = true;
          user = config.bfmp.malenia.username;
        };
      };
    })
  ];
}
