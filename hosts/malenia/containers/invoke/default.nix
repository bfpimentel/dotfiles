{
  config,
  lib,
  vars,
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
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.invoke.rule" = "Host(`invoke.${vars.domain}`)";
          "traefik.http.routers.invoke.entryPoints" = "https";
          "traefik.http.services.invoke.loadbalancer.server.port" = "9090";
          # Homepage
          "homepage.group" = "Misc";
          "homepage.name" = "Invoke AI";
          "homepage.icon" = "sh-invoke-ai-light.svg";
          "homepage.href" = "https://invoke.${vars.domain}";
        };
      };
    };
  };
}
