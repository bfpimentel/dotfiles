{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.streaming;
in
{
  options.bfmp.services.streaming = {
    enable = mkEnableOption "Enable Streaming Services";
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
    };
  };
}
