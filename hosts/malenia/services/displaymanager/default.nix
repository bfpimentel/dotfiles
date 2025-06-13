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
    enableHyprland = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Hyprland. If set to false, will enable Plasma6 instead.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        ignition
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.space-mono
      ];

      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        autoLogin = {
          enable = true;
          user = vars.defaultUser;
        };
      };

    })
    (mkIf (cfg.enable && cfg.enableHyprland) {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
    })
    (mkIf (cfg.enable && !cfg.enableHyprland) {
      services.desktopManager.plasma6.enable = true;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        elisa
      ];
    })
  ];
}
