{
  username,
  config,
  lib,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./users.nix
    ./pkgs.nix
    ./containers
    ./services
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelModules = [ "nvidia-uvm" ];

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  services.xserver.videoDrivers = [ "nvidia" ];

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

  system.stateVersion = "24.05";
}
