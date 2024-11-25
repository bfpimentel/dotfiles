{
  config,
  vars,
  pkgs,
  username,
  ...
}:

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
        config = settingsFormat.generate "config.yml" ((import ./config/config.nix) vars.domain);
        dynamic = settingsFormat.generate "dynamic.yml" (
          (import ./config/dynamic.nix) vars.ip vars.domain vars.godwynIp vars.radagonIp
        );
      };
    };
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 ${username} ${username} - -") (builtins.attrValues traefikPaths.volumes)
    ++ map (x: "f ${x} 0600 ${username} ${username} - -") (builtins.attrValues traefikPaths.files);

  virtualisation.oci-containers.containers = {
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
        "${traefikPaths.files.acme}:/acme.json"
        "${traefikPaths.generated.config}:/traefik.yml:ro"
        "${traefikPaths.generated.dynamic}:/dynamic.yml:ro"
      ];
      environmentFiles = [ config.age.secrets.cloudflare.path ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.traefik.rule" = "Host(`traefik.${vars.domain}`)";
        "traefik.http.routers.traefik.entryPoints" = "https";
        "traefik.http.routers.traefik.service" = "api@internal";
        "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        # Homepage
        "homepage.group" = "Networking";
        "homepage.name" = "Traefik";
        "homepage.icon" = "traefik.svg";
        "homepage.href" = "https://traefik.${vars.domain}";
        "homepage.widget.type" = "traefik";
        "homepage.widget.url" = "http://traefik:8080";
      };
    };
  };
}
