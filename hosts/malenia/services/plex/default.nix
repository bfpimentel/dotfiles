{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  plexPaths =
    let
      root = "${vars.servicesConfigRoot}/plex";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.services.plex;
in
{
  options.bfmp.services.plex = {
    enable = mkEnableOption "Enable Plex";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues plexPaths.volumes
    );

    systemd.services.plex.serviceConfig = {
      User = vars.defaultUser;
      Group = vars.defaultUser;
    };

    services.plex = {
      enable = true;
      openFirewall = true;
      user = vars.defaultUser;
      group = vars.defaultUser;
      # package = plexPassPkg;
      dataDir = plexPaths.volumes.root;
      accelerationDevices = [ "*" ];
    };
  };
}
