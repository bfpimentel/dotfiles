{ ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
    ({ ... }: {
      fileSystems."/mnt/mass" = {
        device = "/dev/disk/by-uuid/123EA1F958F8CE80";
        fsType = "ntfs-3g";
        options = [
          "rw"
          "uid=1000"
        ];
      };
    })
  ];
}
