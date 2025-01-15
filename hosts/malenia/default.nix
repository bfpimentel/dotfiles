{
  vars,
  ...
}:

{
  imports = [
    ./containers
    ./services
    ./filesystems.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./nvidia.nix
    ./users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${vars.defaultUser}.home = "/home/${vars.defaultUser}";

  system.stateVersion = "24.05";
}
