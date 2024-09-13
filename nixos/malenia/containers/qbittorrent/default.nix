{ vars, username, ... }:

let
  qbtPath = "${vars.containersConfigRoot}/qbittorrent/";

  directories = [ 
    qbtPath 
    "${qbtPath}/config"
    "${qbtPath}/themes"
  ];

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];

  virtualisation.oci-containers = {
    containers = {
      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        autoStart = true;
        ports = [
          "127.0.0.1:6881:6881"
          "127.0.0.1:6881:6881/udp"
        ];
        volumes = [ 
          "${vars.mediaMountLocation}/downloads:/downloads" 
          "${qbtPath}/config:/config" 
          "${qbtPath}/themes:/themes" 
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          UMASK = "002";
          TORRENTING_PORT = "6881";
          WEBUI_PORT = "8080";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.qbittorrent.rule" = "Host(`torrent.${vars.domain}`)";
          "traefik.http.routers.qbittorrent.entryPoints" = "https";
          "traefik.http.routers.qbittorrent.service" = "qbittorrent";
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
