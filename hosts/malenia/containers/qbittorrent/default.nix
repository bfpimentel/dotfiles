{ config, lib, ... }:

with lib;
let
  inherit (config.bfmp.malenia) vars;

  qbtPaths =
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
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues qbtPaths.volumes
    );

    networking.firewall.allowedTCPPorts = [ 51123 ];
    networking.firewall.allowedUDPPorts = [ 51123 ];

    virtualisation.oci-containers.containers = {
      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        ports = [
          "51123:51123"
          "51123:51123/udp"
        ];
        volumes = [
          "${qbtPaths.volumes.config}:/config"
          "${qbtPaths.volumes.themes}:/themes"
          "${qbtPaths.mounts.downloads}:/downloads"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
          TORRENTING_PORT = "51123";
          WEBUI_PORT = "8080";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.qbittorrent.rule" = "Host(`torrent.${vars.domain}`)";
          "traefik.http.routers.qbittorrent.entryPoints" = "https";
          "traefik.http.services.qbittorrent.loadbalancer.server.port" = "8080";
          # Homepage
          "homepage.group" = "Download Managers";
          "homepage.name" = "Qbittorrent";
          "homepage.icon" = "qbittorrent.svg";
          "homepage.href" = "https://torrent.${vars.domain}";
        };
      };
    };
  };
}
