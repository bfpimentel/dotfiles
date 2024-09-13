{
  config,
  username,
  vars,
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
        group = username;
        mode = "u=rwx,g=rwx,o=";
      }
    ];
  };

  fileSystems."${vars.mediaMountLocation}" = {
    device = "//${vars.unraidIp}/media";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${toString vars.defaultUserUID}"
      "gid=${toString vars.defaultUserGID}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."${vars.photosMountLocation}" = {
    device = "//${vars.unraidIp}/photos";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${toString vars.defaultUserUID}"
      "gid=${toString vars.defaultUserGID}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."${vars.containersMountLocation}" = {
    device = "//${vars.unraidIp}/containers";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${toString vars.defaultUserUID}"
      "gid=${toString vars.defaultUserGID}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };
}
