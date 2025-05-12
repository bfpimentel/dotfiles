{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.hyprland;
in
{
  options.bfmp.services.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    fonts.packages = with pkgs; [
      nerd-fonts.space-mono
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    services.displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
          kdePackages.qtvirtualkeyboard
        ];
        settings = {
          Autologin = {
            Session = "hyprland-uwsm";
            User = vars.defaultUser;
          };
        };
      };
    };

    programs = {
      hyprland.enable = true;
      uwsm = {
        enable = true;
        waylandCompositors = {
          hyprland = {
            prettyName = "Hyprland";
            comment = "Hyprland compositor manager by UWSM";
            binPath = "/run/current-system/sw/bin/Hyprland";
          };
        };
      };
    };
  };
}
