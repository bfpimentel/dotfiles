{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  invokePaths =
    let
      root = "${vars.containersConfigRoot}/invoke";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.containers.invoke;
in
{
  options.bfmp.containers.invoke = {
    enable = mkEnableOption "Enable Invoke.ai";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues invokePaths.volumes
    );

    virtualisation.oci-containers.containers = {
      invoke = {
        image = "ghcr.io/invoke-ai/invokeai";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "--gpus=all"
        ];
        volumes = [ "${invokePaths.volumes.root}:/data" ];
        environment = {
          INVOKEAI_ROOT = "/data";
        };
        labels = util.mkDockerLabels {
          id = "invoke";
          name = "Invoke AI";
          subdomain = "invoke";
          port = 9090;
        };
      };
    };
  };
}
