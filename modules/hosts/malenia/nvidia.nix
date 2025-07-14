{
  config,
  pkgs,
  lib,
  ...
}:

{
  # boot.kernelModules = [
  #   "nvidia"
  #   "nvidia-uvm"
  # ];

  # environment.systemPackages = with pkgs; [
  #   nvidia-container-toolkit
  #   cudatoolkit
  # ];

  nixpkgs.config.nvidia.acceptLicense = true;

  # environment.variables = {
  #   GBM_BACKEND = "nvidia-drm";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # };

  hardware = {
    # enableRedistributableFirmware = lib.mkDefault true;
    graphics.enable = true;
    nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = true;
    };
    nvidia = {
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
