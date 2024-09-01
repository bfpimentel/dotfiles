{
  vars,
  pkgs,
  config,
  ...
}:

let
  settingsFormat = pkgs.formats.yaml { };
  homepageSettings = {
    docker = settingsFormat.generate "docker.yaml" (import ./config/docker.nix);
    services = settingsFormat.generate "services.yaml" ((import ./config/services.nix) vars.domain);
    widgets = settingsFormat.generate "widgets.yaml" (import ./config/widgets.nix);
    settings = settingsFormat.generate "settings.yaml" (import ./config/settings.nix);
  };
in
{
  virtualisation.oci-containers = {
    containers = {
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
        ];
        environmentFiles = [
          config.age.secrets.radarr.path
          config.age.secrets.sonarr.path
          config.age.secrets.bazarr.path
        ];
        environment = {
          TZ = vars.timeZone;
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
