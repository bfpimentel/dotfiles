{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  pocketIdPaths =
    let
      root = "${vars.containersConfigRoot}/pocket-id";
    in
    {
      inherit root;
      data = "${root}/data";
    };

  cfg = config.bfmp.containers.pocket-id;

  puid = toString vars.defaultUserUID;
  pgid = toString vars.defaultUserGID;
in
{
  options.bfmp.containers.pocket-id = {
    enable = mkEnableOption "Enable Pocket ID";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues pocketIdPaths
    );

    virtualisation.oci-containers.containers = {
      pocket-id = {
        image = "ghcr.io/pocket-id/pocket-id:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${pocketIdPaths.data}:/app/data" ];
        environment = {
          PUID = puid;
          PGID = pgid;
          APP_URL = "https://auth.${vars.domain}";
          TRUST_PROXY = "true";
        };
        labels = util.mkDockerLabels {
          id = "pocket-id";
          name = "Pocket ID";
          subdomain = "auth";
          port = 1411;
        };
      };
    };
  };
}
