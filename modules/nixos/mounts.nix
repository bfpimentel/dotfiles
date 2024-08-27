{ config, lib, pkgs, ... }: 

{
  fileSystems."/mnt/share" = {
    device = "//10.22.4.5/malenia-share/bruno";
    fsType = "cifs";
    options = [ "credentials=/etc/nixos/secrets/share" "uid=2000" "gid=2000" "x-systemd.automount" "noauto" "rw" ];
  };
}
