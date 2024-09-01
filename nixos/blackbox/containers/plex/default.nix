{
  vars,
  username,
  config,
  ...
}:

let
  plexPath = "${vars.containersConfigRoot}/plex";

  directories = [
    "${plexPath}"
    "${plexPath}/config"
  ];

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      plex = {
        image = "lscr.io/linuxserver/plex:latest";
        autoStart = true;
        extraOptions = [ "--device=/dev/dri:/dev/dri" ];
        volumes = [
          "${plexPath}:/config"
          "${vars.storageMountLocation}/media:/media"
        ];
        environmentFiles = [ config.age.secrets.plex.path ];
        environment = {
          "PLEX_UID" = puid;
          "PLEX_GID" = guid;
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
          "homepage.widget.type" = "plex";
          "homepage.widget.key" = "{{HOMEPAGE_VAR_PLEX_KEY}}";
          "homepage.widget.url" = "http://plex:32400";
        };
      };
    };
  };
}
