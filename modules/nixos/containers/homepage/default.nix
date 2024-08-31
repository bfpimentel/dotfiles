{ vars, username, pkgs, ... }:

let
  homepagePath = "${vars.containersConfigRoot}/homepage";

  directories = [
    "${homepagePath}"
    "${homepagePath}/config"
  ];

  settingsFormat = pkgs.formats.yaml { };
  homepageSettings = {
    docker = settingsFormat.generate "${homepagePath}/docker.yaml" (import ./config/docker.nix);
    services = settingsFormat.generate "${homepagePath}/services.yaml" (import ./config/services.nix);
    bookmarks = settingsFormat.generate "${homepagePath}/bookmarks.yaml" (import ./config/bookmarks.nix);
    widgets = settingsFormat.generate "${homepagePath}/widgets.yaml" (import ./config/widgets.nix);
    settings = settingsFormat.generate "${homepagePath}/settings.yaml" (import ./config/settings.nix);
    css = pkgs.writeTextFile {
      name = "${homepagePath}/custom.css";
      text = builtins.readFile ./config/custom.css;
    };
  };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} podman - -") directories;

  virtualisation.oci-containers = {
    containers = {
      homepage = {
        image = "ghcr.io/gethomepage/homepage:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${homepagePath}:/app/config"
          "${homepageSettings.docker}:/app/config/docker.yaml"
          "${homepageSettings.bookmarks}:/app/config/bookmarks.yaml"
          "${homepageSettings.services}:/app/config/services.yaml"
          "${homepageSettings.settings}:/app/config/settings.yaml"
          "${homepageSettings.widgets}:/app/config/widgets.yaml"
          "${homepageSettings.css}:/app/config/custom.css"
          # "${config.age.secrets.sonarrApiKey.path}:/app/config/sonarr.key"
          # "${config.age.secrets.radarrApiKey.path}:/app/config/radarr.key"
          # "${config.age.secrets.jellyfinApiKey.path}:/app/config/jellyfin.key"
        ];
        # environmentFiles = [ config.age.secrets.paperless.path ];
        environment = {
          TZ = vars.timeZone;
          # HOMEPAGE_FILE_SONARR_KEY = "/app/config/sonarr.key";
          # HOMEPAGE_FILE_RADARR_KEY = "/app/config/radarr.key";
          # HOMEPAGE_FILE_JELLYFIN_KEY = "/app/config/jellyfin.key";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.homepage.entrypoints" = "https";
          "traefik.http.routers.homepage.rule" = "Host(`home.${vars.domain}`)";
          "traefik.http.services.homepage.loadbalancer.server.port" = "3000";
          # "traefik.http.routers.homepage.middlewares" = "auth@file";
        };
      };
    };
  };
}
