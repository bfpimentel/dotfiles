{ config, lib, pkgs, ... }:

{
  services.plex = {
    enable = true;
    user = "bruno";
    group = "media";
    openFirewall = true;
    dataDir = "/mnt/share/media";
  };
}
