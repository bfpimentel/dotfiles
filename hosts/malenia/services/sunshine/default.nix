{
  config,
  lib,
  pkgs,
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

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = pkgs.sunshine.override {
        cudaSupport = true;
      };
    };

    # systemd.user.services.sunshine = {
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   wants = [ "graphical-session.target" ];
    #   after = [ "graphical-session.target" ];
    # };
  };
}
