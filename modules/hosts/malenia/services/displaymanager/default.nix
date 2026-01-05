{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.displayManager;
in
{
  options.bfmp.services.displayManager = {
    enable = mkEnableOption "Enable DisplayManager";
    de = mkOption {
      type = types.enum [
        "plasma"
        "hyprland"
        "cosmic"
      ];
      default = "plasma";
      description = "Desktop Environment";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        ignition
        kdePackages.dolphin
      ];

      # fonts.packages = with pkgs; [
      #   nerd-fonts.space-mono
      # ];

      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
    })
    (mkIf (cfg.enable && cfg.de == "hyprland") {
      environment.systemPackages = with pkgs; [
        rose-pine-hyprcursor
        rose-pine-cursor
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      services = {
        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
          };
          autoLogin = {
            enable = true;
            user = vars.defaultUser;
          };
        };
      };
    })
    (mkIf (cfg.enable && cfg.de == "plasma") {
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
      ];

      services = {
        desktopManager.plasma6.enable = true;
        displayManager = {
          defaultSession = "plasma";
          sddm = {
            enable = true;
            wayland.enable = true;
          };
          autoLogin = {
            enable = true;
            user = vars.defaultUser;
          };
        };
      };
    })
    (mkIf (cfg.enable && cfg.de == "cosmic") {
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
      ];

      services = {
        desktopManager.cosmic.enable = true;
        displayManager = {
          cosmic-greeter.enable = true;
          autoLogin = {
            enable = true;
            user = vars.defaultUser;
          };
        };
      };
    })
  ];
}
