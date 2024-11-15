{ vars, username, ... }:

let
  openaudiblePaths =
    let
      root = "${vars.containersConfigRoot}/openaudible";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
      };
      mounts = {
        audiobooks = "${vars.mediaMountLocation}/audiobooks";
      };
    };

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues openaudiblePaths.volumes
  );

  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];

  virtualisation.oci-containers.containers = {
    openaudible = {
      image = "openaudible/openaudible:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "${openaudiblePaths.volumes.config}:/config/OpenAudible"
        "${openaudiblePaths.mounts.audiobooks}:/audiobooks"
      ];
      environment = {
        TZ = vars.timeZone;
        PUID = puid;
        PGID = pgid;
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.openaudible.rule" = "Host(`audible.${vars.domain}`)";
        "traefik.http.routers.openaudible.entryPoints" = "https";
        "traefik.http.services.openaudible.loadbalancer.server.port" = "3000";
        # Homepage
        "homepage.group" = "Media Managers";
        "homepage.name" = "OpenAudible";
        "homepage.icon" = "openaudible.svg";
        "homepage.href" = "https://audible.${vars.domain}";
        "homepage.weight" = "50";
      };
    };
  };
}
