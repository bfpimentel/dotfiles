{ username, vars, ... }:

let
  audioBookshelfPaths =
    let
      root = "${vars.containersConfigRoot}/audiobookshelf";
    in
    {
      volumes = {
        inherit root;
        config = "${root}/config";
        metadata = "${root}/metadata";
      };
      mounts = {
        audiobooks = "${vars.mediaMountLocation}/audiobooks";
        podcasts = "${vars.mediaMountLocation}/podcasts";
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues audioBookshelfPaths.volumes
  );

  virtualisation.oci-containers.containers = with audioBookshelfPaths; {
    audiobookshelf = {
      image = "ghcr.io/advplyr/audiobookshelf:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "${volumes.config}:/config"
        "${volumes.metadata}:/metadata"
        "${mounts.audiobooks}:/audiobooks"
        "${mounts.podcasts}:/podcasts"
      ];
      environment = {
        TZ = vars.timeZone;
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.audiobookshelf.rule" = "Host(`audiobooks.${vars.domain}`)";
        "traefik.http.routers.audiobookshelf.entryPoints" = "https";
        "traefik.http.services.audiobookshelf.loadbalancer.server.port" = "80";
        # Homepage
        "homepage.group" = "Media";
        "homepage.name" = "Audio Bookshelf";
        "homepage.icon" = "audiobookshelf.png";
        "homepage.href" = "https://audiobooks.${vars.domain}";
        "homepage.weight" = "7";
        "homepage.widget.type" = "audiobookshelf";
        "homepage.widget.key" = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_KEY}}";
        "homepage.widget.url" = "http://audiobookshelf:80";
      };
    };
  };
}
