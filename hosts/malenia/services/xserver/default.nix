{
  pkgs,
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.xserver;
in
{
  options.bfmp.services.xserver = {
    enable = mkEnableOption "Enable X11 Server";
    configureHyprland = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to configure Hyprland";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.xserver = {
        enable = true;
        videoDrivers = [ "nvidia" ];
        displayManager.lightdm.enable = false;
      };
    })
    (mkIf cfg.configureHyprland {
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
    })
  ];
}
