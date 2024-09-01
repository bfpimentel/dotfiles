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
    ./services
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

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
