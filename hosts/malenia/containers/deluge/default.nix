{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  delugePaths =
    let
      root = "${vars.containersConfigRoot}/deluge";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        themes = "${root}/themes";
      };
      mounts = {
        downloads = "${vars.mediaMountLocation}/downloads";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.deluge;
in
{
  options.bfmp.containers.deluge = {
    enable = mkEnableOption "Enable Deluge";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues delugePaths.volumes
    );

    networking.firewall.allowedTCPPorts = [ 51123 ];
    networking.firewall.allowedUDPPorts = [ 51123 ];

    virtualisation.oci-containers.containers = {
      deluge = {
        image = "lscr.io/linuxserver/deluge:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        ports = [
          "51123:51123"
          "51123:51123/udp"
        ];
        volumes = [
          "${delugePaths.volumes.config}:/config"
          "${delugePaths.volumes.themes}:/themes"
          "${delugePaths.mounts.downloads}:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "deluge";
          name = "Deluge";
          subdomain = "torrent";
          port = 8112;
        };
      };
    };
  };
}
