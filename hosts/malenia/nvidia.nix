{ lib, config, ... }:

{
  boot.kernelModules = [ "nvidia-uvm" ];

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
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nvidia-container-toolkit.enable = true;
  };
}
