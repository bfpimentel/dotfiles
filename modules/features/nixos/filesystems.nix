{ ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
    (
      { ... }:
      {
        fileSystems."/mnt/mass" = {
          device = "/dev/disk/by-uuid/123EA1F958F8CE80";
          fsType = "ntfs-3g";
          options = [
            "rw"
            "uid=1000"
          ];
        };
      }
    )
  ];

  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      let
        mkNasShare = share: {
          device = "//10.22.4.4/${share}";
          fsType = "cifs";
          options = [
            "rw"
            "uid=1000"
            "gid=100"
            "file_mode=0660"
            "dir_mode=0770"
            "credentials=${config.age.secrets.share-credentials.path}"
          ];
        };
      in
      {
        fileSystems = {
          "/mnt/share/photos" = mkNasShare "photos";
          "/mnt/share/containers" = mkNasShare "containers";
          "/mnt/share/downloads" = mkNasShare "downloads";
          "/mnt/share/media" = mkNasShare "media";
        };
      }
    )
  ];
}
