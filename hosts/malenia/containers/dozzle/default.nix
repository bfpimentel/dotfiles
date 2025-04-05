{
  config,
  lib,
  util,
  ...
}:

with lib;
let
  cfg = config.bfmp.containers.dozzle;
in
{
  options.bfmp.containers.dozzle = {
    enable = mkEnableOption "Enable Dozzle";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      dozzle = {
        image = "amir20/dozzle:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock"
        ];
        labels = util.mkDockerLabels {
          id = "dozzle";
          name = "Dozzle";
          subdomain = "logs";
          port = 8080;
        };
      };
    };
  };
}
