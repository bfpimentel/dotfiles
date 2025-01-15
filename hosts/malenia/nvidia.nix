{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelModules = [ "nvidia-uvm" ];

  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    cudatoolkit
  ];

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
