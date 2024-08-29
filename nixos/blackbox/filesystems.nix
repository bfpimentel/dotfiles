{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  shareCredentialsPath = config.age.secrets.share.path;
in
{
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"

      {
        directory = "/opt/containers";
        user = username;
        group = "podman";
        mode = "u=rwx,g=rw,o=";
      }
      {
        directory = "/opt/services";
        user = username;
        group = username;
        mode = "u=rwx,g=rw,o=";
      }
    ];
  };

  fileSystems."/mnt/share" = {
    device = "//10.22.4.5/malenia-share/bruno";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=2000"
      "gid=2000"
      "x-systemd.automount"
      "noauto"
      "rw"
    ];
  };
}
