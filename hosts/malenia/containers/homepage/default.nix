{
  vars,
  pkgs,
  config,
  username,
  ...
}:

let
  homepagePath = "${vars.containersConfigRoot}/homepage";

  settingsFormat = pkgs.formats.yaml { };

  homepageSettings = {
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
    images = "${homepagePath}/images";
  };

  directories = [
    "${homepagePath}"
    "${homepagePath}/images"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers.containers = {
    homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
        "${homepageSettings.docker}:/app/config/docker.yaml"
        "${homepageSettings.services}:/app/config/services.yaml"
        "${homepageSettings.settings}:/app/config/settings.yaml"
        "${homepageSettings.widgets}:/app/config/widgets.yaml"
        "${homepageSettings.bookmarks}:/app/config/bookmarks.yaml"
        "${homepageSettings.css}:/app/config/custom.css"
        "${homepageSettings.images}:/app/public/images"
      ];
      environmentFiles = [
        config.age.secrets.radarr.path
        config.age.secrets.sonarr.path
        config.age.secrets.bazarr.path
        config.age.secrets.plex.path
        config.age.secrets.immich.path
        config.age.secrets.jellyfin.path
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
