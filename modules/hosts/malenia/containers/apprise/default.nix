{
  config,
  lib,
  vars,
  pkgs,
  util,
  ...
}:

with lib;
let
  apprisePaths =
    let
      root = "${vars.containersConfigRoot}/apprise";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        attachments = "${root}/attachments";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.apprise;
in
{
  options.bfmp.containers.apprise = {
    enable = mkEnableOption "Enable Apprise";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      apprise
    ];

    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues apprisePaths.volumes
    );

    virtualisation.oci-containers.containers = {
      apprise = {
        image = "lscr.io/linuxserver/apprise-api:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${apprisePaths.volumes.config}:/config"
          "${apprisePaths.volumes.attachments}:/attachments"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          APPRISE_ATTACH_SIZE = "10";
        };
        labels = util.mkDockerLabels {
          id = "apprise";
          name = "Apprise";
          subdomain = "notify";
          port = 8000;
        };
      };
    };
  };
}
