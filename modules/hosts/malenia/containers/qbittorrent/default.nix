{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  qbittorrentPaths =
    let
      root = "${vars.containersConfigRoot}/qbittorrent";
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

  qbittorrentSeedPaths =
    let
      root = "${vars.containersConfigRoot}/qbittorrent-seed";
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

  cfg = config.bfmp.containers.qbittorrent;
in
{
  options.bfmp.containers.qbittorrent = {
    enable = mkEnableOption "Enable Qbittorrent";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues qbittorrentPaths.volumes
      )
      ++ map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues qbittorrentSeedPaths.volumes
      );

    networking.firewall.allowedTCPPorts = [ 51123 ];
    networking.firewall.allowedUDPPorts = [ 51123 ];

    virtualisation.oci-containers.containers = {
      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        ports = [
          "51123:51123"
          "51123:51123/udp"
        ];
        volumes = [
          "${qbittorrentPaths.volumes.config}:/config"
          "${qbittorrentPaths.volumes.themes}:/themes"
          "${qbittorrentPaths.mounts.downloads}:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          WEBUI_PORT = "8080";
          TORRENTING_PORT = "51123";
        };
        labels = util.mkDockerLabels {
          id = "qbittorrent";
          name = "Qbittorrent";
          subdomain = "torrent";
          port = 8080;
        };
      };
      qbittorrent-seed = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        ports = [
          "51124:51124"
          "51124:51124/udp"
        ];
        volumes = [
          "${qbittorrentSeedPaths.volumes.config}:/config"
          "${qbittorrentSeedPaths.volumes.themes}:/themes"
          "${qbittorrentSeedPaths.mounts.seed}:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          WEBUI_PORT = "8080";
          TORRENTING_PORT = "51124";
        };
        labels = util.mkDockerLabels {
          id = "qbittorrent-seed";
          icon = "Qbittorrent";
          name = "Qbittorrent (Seed)";
          subdomain = "seed";
          port = 8080;
        };
      };
    };
  };
}
