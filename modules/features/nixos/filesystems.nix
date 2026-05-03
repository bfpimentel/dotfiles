{ inputs, ... }:

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
            "forceuid"
            "forcegid"
            "file_mode=0660"
            "dir_mode=0770"
            "credentials=${config.age.secrets.share-credentials.path}"
          ];
        };
      in
      {
        fileSystems = {
          "/mnt/mass" = {
            device = "/dev/disk/by-id/ata-HSSD001256_S25564J0802829-part1";
            fsType = "ext4";
            options = [
              "rw"
              "nofail"
              "x-systemd.device-timeout=10s"
            ];
          };

          "/mnt/share/photos" = mkNasShare "photos";
          "/mnt/share/containers" = mkNasShare "containers";
          "/mnt/share/downloads" = mkNasShare "downloads";
          "/mnt/share/media" = mkNasShare "media";
        };

        systemd.tmpfiles.rules = [
          "d /mnt/mass 0755 bruno users -"
        ];
      }
    )
  ];
}
