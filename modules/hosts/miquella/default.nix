{ vars, ... }:

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

  time.timeZone = vars.timeZone;

  users.users.${vars.defaultUser}.home = "/home/${vars.defaultUser}";

  system.stateVersion = "24.11";
}
