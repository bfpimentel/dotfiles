{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;

  cfg = config.bfmp.containers.tinyauth;
in
{
  options.bfmp.containers.tinyauth = {
    enable = mkEnableOption "Enable Tinyauth";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      tinyauth = {
        image = "ghcr.io/steveiliop56/tinyauth:nightly";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        environmentFiles = [ config.age.secrets.tinyauth.path ];
        environment = {
          TZ = vars.timeZone;
          PUID = puid;
          PGID = pgid;
          LOG_LEVEL = "0";
        };
        volumes = [ "/var/run/docker.sock:/var/run/docker.sock:ro" ];
        labels = util.mkDockerLabels {
          id = "tinyauth";
          name = "Tinyauth";
          subdomain = "tinyauth";
          port = 3000;
        };
      };
    };
  };
}
