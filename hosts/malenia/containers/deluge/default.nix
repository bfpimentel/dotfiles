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
        seed = "${vars.mediaMountLocation}/seed";
      };
    };

  delugeSeedPaths =
    let
      root = "${vars.containersConfigRoot}/deluge-seed";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        themes = "${root}/themes";
      };
      mounts = {
        seed = "${vars.mediaMountLocation}/seed";
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
    systemd.tmpfiles.rules =
      map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues delugePaths.volumes
      )
      ++ map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues delugeSeedPaths.volumes
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
      deluge-seed = {
        image = "lscr.io/linuxserver/deluge:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        ports = [
          "51124:51124"
          "51124:51124/udp"
        ];
        volumes = [
          "${delugeSeedPaths.volumes.config}:/config"
          "${delugeSeedPaths.volumes.themes}:/themes"
          "${delugeSeedPaths.mounts.seed}:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
        };
        labels = util.mkDockerLabels {
          id = "deluge-seed";
          icon = "deluge";
          name = "Deluge (Seed)";
          subdomain = "seed";
          port = 8112;
        };
      };
    };
  };
}
