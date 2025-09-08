{
  vars,
  pkgs,
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
    ./pkgs.nix
    ./users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelParams = [ "fsck.mode=force" ];

  time.timeZone = vars.timeZone;

  users.users.${vars.defaultUser}.home = "/home/${vars.defaultUser}";

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  powerManagement.enable = false;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  system.stateVersion = "24.05";
}
