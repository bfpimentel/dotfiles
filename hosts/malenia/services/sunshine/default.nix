{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.sunshine;
in
{
  options.bfmp.services.sunshine = {
    enable = mkEnableOption "Enable Sunshine";
  };

  config = mkIf cfg.enable {
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
    services.udisks2.enable = mkForce false;

    boot.kernelModules = [ "uinput" ];

    # services.sunshine = {
    #   enable = true;
    #   autoStart = true;
    #   capSysAdmin = true;
    #   openFirewall = true;
    #   package = pkgs.sunshine.override {
    #     cudaSupport = true;
    #   };
    # };

    services.apollo = {
      enable = true;
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
                  ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-0,2880x1864@60,0x0,1
                '';
                undo = ''
                  ${pkgs.hyprland}/bin/hyprctl keyword monitor HDMI-0,3840x2160@60,0x0,1
                '';
              }
            ];
          }
        ];
      };
    };
  };
}
