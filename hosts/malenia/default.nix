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

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "24.05";
}
