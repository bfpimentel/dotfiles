{ config, lib, pkgs, ... }: let
  credentialsPath = toString ../../secrets/share;
in {
  fileSystems."/mnt/share" = {
    device = "//10.22.4.5/malenia-share/bruno";
    fsType = "cifs";
    options = [ "credentials=${credentialsPath}" "uid=2000" "gid=2000" "x-systemd.automount" "noauto" "rw" ];
  };
}
