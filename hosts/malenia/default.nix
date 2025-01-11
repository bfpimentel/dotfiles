{ username, config,
  lib,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./networking.nix
    ./nvidia.nix
    ./users.nix
    ./pkgs.nix
    ./containers
    ./services
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  # hardware.pulseaudio.enable = true;
  # security.rtkit.enable = true;

  system.stateVersion = "24.05";
}
