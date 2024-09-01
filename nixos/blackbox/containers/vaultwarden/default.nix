{
  vars,
  username,
  config,
  ...
}:
let
  vaultwardenPath = "${vars.containersConfigRoot}/vaultwarden/";

  directories = [ vaultwardenPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      vaultwarden = {
        image = "vaultwarden/server:latest";
        autoStart = true;
        volumes = [ "${vaultwardenPath}:/data" ];
        environmentFiles = [ config.age.secrets.vaultwarden.path ];
        environment = {
          DOMAIN = "https://vault.${vars.domain}";
          LOGIN_RATELIMIT_MAX_BURST = "10";
          LOGIN_RATELIMIT_SECONDS = "60";
          ADMIN_RATELIMIT_MAX_BURST = "10";
          ADMIN_RATELIMIT_SECONDS = "60";
          SENDS_ALLOWED = "true";
          EMERGENCY_ACCESS_ALLOWED = "true";
          WEB_VAULT_ENABLED = "true";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.vaultwarden.rule" = "Host(`vault.${vars.domain}`)";
          "traefik.http.routers.vaultwarden.entryPoints" = "https";
          "traefik.http.routers.vaultwarden.service" = "vaultwarden";
          "traefik.http.services.vaultwarden.loadbalancer.server.port" = "80";
          # Homepage
          "homepage.group" = "Auth";
          "homepage.name" = "Vaultwarden";
          "homepage.icon" = "vaultwarden.svg";
          "homepage.href" = "https://vault.${vars.domain}";
        };
      };
    };
  };
}
