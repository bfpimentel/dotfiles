{
  username,
  vars,
  pkgs,
  ...
}:

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
        server = settingsFormat.generate "${root}/data/server.yml" (
          (import ./config/server.nix) vars.externalDomain
        );
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
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
        # Homepage
        "homepage.group" = "Misc";
        "homepage.name" = "Ntfy";
        "homepage.icon" = "ntfy.svg";
        "homepage.href" = "https://notify.${vars.externalDomain}";
      };
    };
  };
}
