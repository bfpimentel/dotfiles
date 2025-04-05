{
  config,
  lib,
  vars,
  pkgs,
  util,
  ...
}:

with lib;
let
  glancePaths =
    let
      settingsFormat = pkgs.formats.yaml { };
      root = "${vars.containersConfigRoot}/glance";
    in
    {
      volumes = {
        inherit root;
      };
      generated = {
        glance = settingsFormat.generate "glance.yml" (import ./config/glance.nix);
      };
    };

  cfg = config.bfmp.containers.glance;
in
{
  options.bfmp.containers.glance = {
    enable = mkEnableOption "Enable Glance Dashboard";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues glancePaths.volumes
    );

    virtualisation.oci-containers.containers = {
      glance = {
        image = "glanceapp/glance:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${glancePaths.generated.glance}:/app/config/glance.yml"
        ];
        labels = util.mkDockerLabels {
          id = "glance";
          name = "Glance";
          subdomain = "dash";
          port = 8080;
        };
      };
    };
  };
}
