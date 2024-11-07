{
  config,
  username,
  vars,
  ...
}:

let
  shareCredentialsPath = config.age.secrets.share.path;

  puid = toString vars.defaultUserUID;
  guid = toString vars.defaultUserGID;
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
      {
        directory = "/opt/services";
        user = username;
        group = username;
        mode = "u=rwx,g=rwx,o=";
      }
    ];
  };

  fileSystems."${vars.mediaMountLocation}" = {
    device = "//${vars.godwynIp}/media";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${puid}"
      "gid=${guid}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."${vars.photosMountLocation}" = {
    device = "//${vars.godwynIp}/photos";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${puid}"
      "gid=${guid}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."${vars.documentsMountLocation}" = {
    device = "//${vars.godwynIp}/documents";
    fsType = "cifs";
    options = [
      "credentials=${shareCredentialsPath}"
      "uid=${puid}"
      "gid=${guid}"
      "rw"
      "noserverino"
      "x-systemd.automount"
      "noauto"
    ];
  };
}
