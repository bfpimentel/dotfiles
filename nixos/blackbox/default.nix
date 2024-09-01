{
  username,
  config,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./filesystems.nix
    ./containers
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # boot = {
  #   initrd.kernelModules = [
  #     "vfio_pci"
  #     "vfio"
  #     "vfio_iommu_type1"
  #     "vfio_virqfd"

  #     "nvidia"
  #     "nvidia_modeset"
  #     "nvidia_uvm"
  #     "nvidia_drm"
  #   ];

  #   kernelParams = [ "vfio-pci.ids=10de:1b80,10de:10f0" ];
  # };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    graphics.enable = true;
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement = {
        finegrained = false;
        enable = false;
      };
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    nvidia-container-toolkit.enable = true;
  };

  users.users.${username}.home = "/home/${username}";

  system.stateVersion = "24.05";
}
