{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.plex = {
    enable = true;
    user = "media";
    group = "media";
    openFirewall = true;
    dataDir = "/opt/media/plex";
  };

  systemd.services.plex = {
    after = [ "mnt-share.mount" ];
  };
}
