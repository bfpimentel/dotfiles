{
  config,
  vars,
  pkgs,
  ...
}:
let
  directories = [ "${vars.containersConfigRoot}/traefik" ];
  files = [ "${vars.containersConfigRoot}/traefik/acme.json" ];

  settingsFormat = pkgs.formats.yaml { };
  traefikConfig = {
    config = settingsFormat.generate "config.yaml" (import ./config/config.nix);
    dynamic = settingsFormat.generate "dynamic.yaml" (import ./config/dynamic.nix);
  };
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 share share - -") directories
    ++ map (x: "f ${x} 0600 share share - -") files;

  virtualisation.oci-containers = {
    containers = {
      traefik = {
        image = "traefik:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        ports = [
          "443:443"
          "80:80"
        ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${vars.containersConfigRoot}/traefik/acme.json:/acme.json"
          "${traefikConfig.config}:/traefik.yml:ro"
          "${traefikConfig.dynamic}:/dynamic.yml:ro"
        ];
        environmentFiles = [ config.age.secrets.cloudflare.path ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`traefik.${vars.domain}`)";
          "traefik.http.routers.traefik.entryPoints" = "https";
          "traefik.http.routers.traefik.service" = "api@internal";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
          "homepage.group" = "Services";
          "homepage.name" = "Traefik";
          "homepage.icon" = "traefik.svg";
          "homepage.href" = "https://traefik.${vars.domain}";
          "homepage.description" = "Reverse proxy";
          "homepage.widget.type" = "traefik";
          "homepage.widget.url" = "http://traefik:8080";
        };
      };
    };
  };
}
