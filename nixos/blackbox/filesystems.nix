{ config, username, vars, ... }:

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
        group = username;
        mode = "u=rwx,g=rwx,o=";
      }
    ];
  };

#  fileSystems."${vars.storageMountLocation}" = {
#    device = "//10.22.4.5/malenia-share/bruno";
#    fsType = "cifs";
#    options = [
#      "credentials=${shareCredentialsPath}"
#      "uid=${toString vars.defaultUserUID}"
#      "gid=${toString vars.defaultUserGID}"
#      "x-systemd.automount"
#      "noauto"
#      "rw"
#    ];
#  };
}
