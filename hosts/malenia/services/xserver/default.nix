{
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
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
  };
}
