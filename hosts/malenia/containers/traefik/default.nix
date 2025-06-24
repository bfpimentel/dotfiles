{
  config,
  lib,
  vars,
  pkgs,
  util,
  ...
}:

with lib;
let
  traefikPaths =
    let
      settingsFormat = pkgs.formats.yaml { };
      root = "${vars.containersConfigRoot}/traefik";
    in
    {
      volumes = {
        inherit root;
      };
      files = {
        acme = "${root}/acme.json";
      };
      generated = {
        static = settingsFormat.generate "static.yml" ((import ./config/static.nix) vars);
        dynamic = settingsFormat.generate "dynamic.yml" ((import ./config/dynamic.nix) vars);
        auth = config.age.secrets.traefik-auth.path;
      };
    };

  cfg = config.bfmp.containers.traefik;
in
{
  options.bfmp.containers.traefik = {
    enable = mkEnableOption "Enable Traefik";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemd.tmpfiles.rules =
      map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues traefikPaths.volumes
      )
      ++ map (x: "f ${x} 0600 ${vars.defaultUser} ${vars.defaultUser} - -") (
        builtins.attrValues traefikPaths.files
      );

    virtualisation.oci-containers.containers = {
      traefik = {
        image = "traefik:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        ports = [
          "443:443"
          "80:80"
        ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "${traefikPaths.files.acme}:/acme.json"
          "${traefikPaths.generated.static}:/traefik.yml:ro"
          "${traefikPaths.generated.dynamic}:/config/dynamic.yml:ro"
          "${traefikPaths.generated.auth}:/config/auth.yml:ro"
        ];
        environmentFiles = [ config.age.secrets.cloudflare.path ];
        labels =
          util.mkDockerLabels {
            id = "traefik";
            name = "Traefik";
            subdomain = "traefik";
            port = 8080;
          }
          // {
            "traefik.http.routers.traefik.service" = "api@internal";
          };
      };
    };
  };
}
