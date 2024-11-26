{ username, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./filesystems.nix
    ./containers
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  networking = {
    networkmanager.enable = false;
  };

  system.stateVersion = "24.11";
}

