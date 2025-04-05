{
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  ntfyPaths =
    let
      settingsFormat = pkgs.formats.yaml { };
      root = "${vars.containersConfigRoot}/ntfy";
    in
    {
      volumes = {
        inherit root;
        cache = "${root}/cache";
        data = "${root}/data";
      };
      generated = {
        server = settingsFormat.generate "${root}/data/server.yml" ((import ./config/server.nix) vars);
      };
    };

  cfg = config.bfmp.containers.ntfy;
in
{
  options.bfmp.containers.ntfy = {
    enable = mkEnableOption "Enable Ntfy";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
      builtins.attrValues ntfyPaths.volumes
    );

    virtualisation.oci-containers.containers = {
      ntfy = {
        image = "binwiederhier/ntfy:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        cmd = [ "serve" ];
        ports = [ "9012:80" ];
        environment = {
          TZ = vars.timeZone;
        };
        volumes = [
          "${ntfyPaths.volumes.cache}:/var/cache/ntfy"
          "${ntfyPaths.volumes.data}:/etc/ntfy"
          "${ntfyPaths.generated.server}:/etc/ntfy/server.yml"
        ];
        labels = {
          "glance.id" = "ntfy";
          "glance.name" = "Ntfy";
          "glance.icon" = "si:ntfy";
          "glance.url" = "https://notify.${vars.domain}";
        };
      };
    };
  };
}
