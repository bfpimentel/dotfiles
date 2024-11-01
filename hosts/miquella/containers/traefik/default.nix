{
  config,
  vars,
  pkgs,
  username,
  ...
}:

let
  traefikPath = "${vars.containersConfigRoot}/traefik";

  directories = [ traefikPath ];
  files = [ "${traefikPath}/acme.json" ];

  settingsFormat = pkgs.formats.yaml { };
  traefikConfig = {
    config = settingsFormat.generate "config.yml" ((import ./config/config.nix) vars.domain);
    dynamic = settingsFormat.generate "dynamic.yml" ((import ./config/dynamic.nix) vars.domain);
  };
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 ${username} ${username} - -") directories
    ++ map (x: "f ${x} 0600 ${username} ${username} - -") files;

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
          "${traefikPath}/acme.json:/acme.json"
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
        };
      };
    };
  };
}
