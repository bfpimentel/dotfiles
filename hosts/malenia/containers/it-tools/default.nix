{
  config,
  lib,
  util,
  ...
}:

with lib;
let
  cfg = config.bfmp.containers.it-tools;
in
{
  options.bfmp.containers.it-tools = {
    enable = mkEnableOption "Enable IT-Tools";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      it-tools = {
        image = "corentinth/it-tools";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        labels = util.mkDockerLabels {
          id = "it-tools";
          name = "IT Tools";
          subdomain = "tools";
          port = 80;
        };
      };
    };
  };
}
