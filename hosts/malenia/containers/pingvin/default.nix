{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  pingvinPaths =
    let
      root = "${vars.containersConfigRoot}/pingvin";
    in
    {
      volumes = {
        inherit root;
        data = "${root}/data";
        images = "${root}/images";
      };
    };

  cfg = config.bfmp.containers.pingvin;
in
{
  options.bfmp.containers.pingvin = {
    enable = mkEnableOption "Enable Pingvin";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues pingvinPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      pingvin = {
        image = "ghcr.io/stonith404/pingvin-share";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "${pingvinPaths.volumes.data}:/opt/app/backend/data"
          "${pingvinPaths.volumes.images}:/opt/app/frontend/public/img"
        ];
        environment = {
          TRUST_PROXY = "true";
        };
        labels = util.mkDockerLabels {
          id = "pingvin";
          name = "Pingvin";
          subdomain = "upload";
          port = 3000;
          icon = "pingvin-share";
        };
      };
    };
  };
}
