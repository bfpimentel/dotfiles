{ config, lib, pkgs, username, ... }: let
  shareCredentialsPath = config.age.secrets.share.path;
in {
  fileSystems."/mnt/share" = {
    device = "//10.22.4.5/malenia-share/bruno";
    fsType = "cifs";
    options = [ 
      "credentials=${shareCredentialsPath}" 
      # "credentials=/home/${username}/.secrets/share" 
      "uid=2000" 
      "gid=2000" 
      "x-systemd.automount" 
      "noauto" 
      "rw" 
    ];
  };
}
