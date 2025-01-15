{
  config,
  lib,
  vars,
  pkgs,
  ...
}:

with lib;
let
  jellyfinPaths =
    let
      root = "${vars.servicesConfigRoot}/jellyfin";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.services.jellyfin;
in
{
  options.bfmp.services.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.mapAttrs jellyfinPaths.volumes
    );

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
      user = vars.defaultUser;
      configDir = jellyfinPaths.volumes.root;
    };
  };
}
