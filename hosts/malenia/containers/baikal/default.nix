{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  baikalPaths =
    let
      root = "${vars.containersConfigRoot}/baikal";
    in
    {
      inherit root;
      data = "${root}/data";
      config = "${root}/config";
    };

  cfg = config.bfmp.containers.baikal;
in
{
  options.bfmp.containers.baikal = {
    enable = mkEnableOption "Enable Baikal";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues baikalPaths
    );

    virtualisation.oci-containers.containers = {
      baikal = {
        image = "ckulka/baikal:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "${baikalPaths.data}:/var/www/baikal/Specific"
          "${baikalPaths.config}:/var/www/baikal/config"
        ];
        labels = util.mkDockerLabels {
          id = "baikal";
          name = "Baikal";
          subdomain = "baikal";
          port = 80;
        };
      };
    };
  };
}
