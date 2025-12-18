{
  config,
  ...
}:

{
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware = {
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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
