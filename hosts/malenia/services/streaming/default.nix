{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.streaming;
in
{
  options.bfmp.services.streaming = {
    enable = mkEnableOption "Enable Streaming Services";
    enableApollo = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Apollo. If set to false, will enable Sunshine instead.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.avahi.publish.enable = true;
      services.avahi.publish.userServices = true;
      services.udisks2.enable = mkForce false;

      boot.kernelModules = [ "uinput" ];
    })
    (mkIf (cfg.enable && cfg.enableApollo) {
      services.apollo = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
        package = inputs.apollo.packages.${pkgs.system}.default;
        applications = {
          apps = [
            {
              name = "solaire";
              exclude-global-prep-cmd = "false";
              auto-detach = "true";
              prep-cmd = [
                {
                  do = ''
                    ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-1,2880x1864@60,0x0,1
                  '';
                  undo = ''
                    ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-1,2560x1440@144.91,0x0,1
                  '';
                }
              ];
            }
            {
              name = "brunoS25U";
              exclude-global-prep-cmd = "false";
              auto-detach = "true";
              prep-cmd = [
                {
                  do = ''
                    ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-1,2340x1080@60,0x0,1
                  '';
                  undo = ''
                    ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-1,2560x1440@144.91,0x0,1
                  '';
                }
              ];
            }
          ];
        };
      };
    })
    (mkIf (cfg.enable && !cfg.enableApollo) {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
        package = pkgs.sunshine.override {
          cudaSupport = true;
        };
      };
    })
  ];
}
