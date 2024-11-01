{ username, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./networking.nix
    ./filesystems.nix
    ./containers
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  system.stateVersion = "24.11";
}

