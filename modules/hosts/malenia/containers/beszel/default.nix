{
  config,
  lib,
  vars,
  util,
  ...
}:

with lib;
let
  beszelPaths =
    let
      root = "${vars.containersConfigRoot}/beszel";
    in
    {
      volumes = {
        inherit root;
      };
    };

  cfg = config.bfmp.containers.beszel;
in
{
  options.bfmp.containers.beszel = {
    enable = mkEnableOption "Enable Beszel and Beszel Agent";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues beszelPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      beszel = {
        image = "henrygd/beszel:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [ "${beszelPaths.volumes.root}:/beszel_data" ];
        labels = util.mkDockerLabels {
          id = "beszel";
          name = "Beszel";
          subdomain = "monitor";
          port = 8090;
        };
      };
      beszel-agent = {
        image = "henrygd/beszel-agent:latest";
        autoStart = true;
        extraOptions = [ "--pull=always" ];
        networks = [ "local" ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "${vars.mediaMountLocation}:/extra-filesystems/storage:ro"
        ];
        environment = {
          PORT = "45876";
          KEY = builtins.readFile config.age.secrets.beszel.path; # need to use anti-pattern here.
        };
        labels = {
          "glance.parent" = "beszel";
          "glance.name" = "Agent";
        };
      };
    };
  };
}
