{
  username,
  vars,
  pkgs,
  ...
}:

let
  ntfyPath = "${vars.containersConfigRoot}/ntfy";

  directories = [
    "${ntfyPath}"
    "${ntfyPath}/cache"
    "${ntfyPath}/data"
  ];

  settingsFormat = pkgs.formats.yaml { };
  ntfySettings = {
    server = settingsFormat.generate "${ntfyPath}/data/server.yml" (
      (import ./config/server.nix) vars.externalDomain
    );
  };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

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
        "${ntfyPath}/cache:/var/cache/ntfy"
        "${ntfyPath}/data:/etc/ntfy"
        "${ntfySettings.server}:/etc/ntfy/server.yml"
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
