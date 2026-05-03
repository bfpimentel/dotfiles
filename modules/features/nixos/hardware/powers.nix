{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      # Generated configuration. Override through other modules.
      {
        config,
        lib,
        pkgs,
        modulesPath,
        ...
      }:

      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "uas"
          "sd_mod"
          "sdhci_acpi"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/3bfb9733-20d8-45f8-86e5-ad3c1b4fb482";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/E903-0604";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [
          { device = "/dev/disk/by-uuid/5d7b5fb4-6627-4052-a0d2-fbcb7985998d"; }
        ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      }
    )
  ];
}
