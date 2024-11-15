{
  vars,
  pkgs,
  config,
  username,
  ...
}:

let
  homepagePaths =
    let
      settingsFormat = pkgs.formats.yaml { };
      root = "${vars.containersConfigRoot}/homepage";
    in
    {
      volumes = {
        inherit root;
        images = "${root}/images";
      };
      generated = {
        docker = settingsFormat.generate "docker.yaml" (import ./config/docker.nix);
        services = settingsFormat.generate "services.yaml" (
          (import ./config/services.nix) vars.domain vars.networkInterface
        );
        widgets = settingsFormat.generate "widgets.yaml" (import ./config/widgets.nix);
        settings = settingsFormat.generate "settings.yaml" (import ./config/settings.nix);
        css = pkgs.writeTextFile {
          name = "custom.css";
          text = builtins.readFile ./config/custom.css;
        };
        bookmarks = pkgs.writeTextFile {
          name = "bookmarks.yaml";
          text = "---";
        };
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues homepagePaths.volumes
  );

  virtualisation.oci-containers.containers = {
    homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
        "${homepagePaths.generated.docker}:/app/config/docker.yaml"
        "${homepagePaths.generated.services}:/app/config/services.yaml"
        "${homepagePaths.generated.settings}:/app/config/settings.yaml"
        "${homepagePaths.generated.widgets}:/app/config/widgets.yaml"
        "${homepagePaths.generated.bookmarks}:/app/config/bookmarks.yaml"
        "${homepagePaths.generated.css}:/app/config/custom.css"
        "${homepagePaths.volumes.images}:/app/public/images"
      ];
      environmentFiles = [
        config.age.secrets.immich.path
        config.age.secrets.audiobookshelf.path
        config.age.secrets.jellyfin.path
        config.age.secrets.radarr.path
        config.age.secrets.readarr.path
        config.age.secrets.sonarr.path
        config.age.secrets.bazarr.path
        config.age.secrets.prowlarr.path
        config.age.secrets.plex.path
      ];
      environment = {
        TZ = vars.timeZone;
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homepage.entrypoints" = "https";
        "traefik.http.routers.homepage.rule" = "Host(`dash.${vars.domain}`)";
        "traefik.http.services.homepage.loadbalancer.server.port" = "3000";
      };
    };
  };
}
