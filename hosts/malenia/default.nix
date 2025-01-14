{
  username,
  config,
  lib,
  vars,
  ...
}:

{
  imports = [
    ./containers
    ./services
    ./hardware-configuration.nix
    ./filesystems.nix
    ./networking.nix
    ./nvidia.nix
    ./users.nix
    ./pkgs.nix
    ./options.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  system.stateVersion = "24.05";
}
