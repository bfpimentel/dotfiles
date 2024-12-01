{
  vars,
  username,
  config,
  ...
}:
let
  vaultwardenPaths =
    let
      root = "${vars.containersConfigRoot}/vaultwarden";
    in
    {
      volumes = {
        inherit root;
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues vaultwardenPaths.volumes
  );

  virtualisation.oci-containers.containers = {
    vaultwarden = {
      image = "vaultwarden/server:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      ports = [ "9045:80" ];
      volumes = [ "${vaultwardenPaths.volumes.root}:/data" ];
      environmentFiles = [ config.age.secrets.vaultwarden.path ];
      environment = {
        DOMAIN = "https://vault.${vars.externalDomain}";
        LOGIN_RATELIMIT_MAX_BURST = "10";
        LOGIN_RATELIMIT_SECONDS = "60";
        ADMIN_RATELIMIT_MAX_BURST = "10";
        ADMIN_RATELIMIT_SECONDS = "60";
        SENDS_ALLOWED = "true";
        EMERGENCY_ACCESS_ALLOWED = "true";
        WEB_VAULT_ENABLED = "true";
      };
      labels = {
        # Homepage
        "homepage.group" = "Management";
        "homepage.name" = "Vaultwarden";
        "homepage.icon" = "vaultwarden.svg";
        "homepage.href" = "https://vault.${vars.externalDomain}";
      };
    };
  };
}
