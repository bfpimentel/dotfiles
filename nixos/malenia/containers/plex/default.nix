{
  vars,
  username,
  config,
  ...
}:

let
  plexPath = "${vars.containersConfigRoot}/plex";

  directories = [ "${plexPath}" ];

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    9029
    32400
  ];
  networking.firewall.interfaces."tailscale0".allowedUDPPorts = [
    9029
    32400
  ];

  systemd.services."podman-plex" = {
    wants = [ "podman-tailscale.service" ];
    after = [ "podman-tailscale.service" ];
  };

  virtualisation.oci-containers = {
    containers = {
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        autoStart = true;
        extraOptions = [
          "--device=nvidia.com/gpu=all"
          "--security-opt=label=disable"
          "--network=podman"
          # "--network=public"
        ];
        volumes = [
          "${plexPath}:/config"
          "${vars.mediaMountLocation}/movies:/media/movies"
          "${vars.mediaMountLocation}/shows:/media/shows"
          "${vars.mediaMountLocation}/anime:/media/anime"
        ];
        ports = [ "9029:32400" ];
        environmentFiles = [ config.age.secrets.plex.path ];
        environment = {
          "PUID" = puid;
          "PGID" = guid;
          "TZ" = vars.timeZone;
          "ADVERTISE_IP" = "https://plex.${vars.domain}";
          "NVIDIA_VISIBLE_DEVICES" = "all";
          "NVIDIA_DRIVER_CAPABILITIES" = "all";
          "VERSION" = "docker";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.plex.rule" = "Host(`plex.${vars.domain}`)";
          "traefik.http.routers.plex.entryPoints" = "https";
          "traefik.http.services.plex.loadbalancer.server.port" = "32400";
          # Homepage
          "homepage.group" = "Media";
          "homepage.name" = "Plex";
          "homepage.icon" = "plex.svg";
          "homepage.href" = "https://plex.${vars.domain}";
          "homepage.weight" = "5";
          "homepage.widget.type" = "tautulli";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_PLEX_KEY}}";
          "homepage.widget.url" = "http://tautulli:8181";
          "homepage.widget.enableUser" = "true";
        };
      };
    };
  };
}
