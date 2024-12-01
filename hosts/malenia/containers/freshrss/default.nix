{
  username,
  vars,
  config,
  ...
}:

let
  freshrssPaths =
    let
      root = "${vars.containersConfigRoot}/freshrss";
    in
    {
      inherit root;
      config = "${root}/config";
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues freshrssPaths
  );

  virtualisation.oci-containers.containers = {
    freshrss = {
      image = "lscr.io/linuxserver/freshrss:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "${freshrssPaths.config}:/config"
      ];
      environmentFiles = [ config.age.secrets.freshrss.path ];
      environment = {
        TZ = vars.timeZone;
        PUID = puid;
        PGID = pgid;
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.freshrss.rule" = "Host(`rss.${vars.domain}`)";
        "traefik.http.routers.freshrss.entryPoints" = "https";
        "traefik.http.services.freshrss.loadbalancer.server.port" = "80";
        # Homepage
        "homepage.group" = "Documents";
        "homepage.name" = "FreshRSS";
        "homepage.icon" = "freshrss.png";
        "homepage.href" = "https://rss.${vars.domain}";
      };
    };
  };
}
