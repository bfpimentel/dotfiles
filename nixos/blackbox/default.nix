{ hostname, username, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "${hostname}";
    interfaces = {
      enp6s18.ipv4.addresses = [
        {
          address = vars.ip;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.22.4.1";
  };

  users.users.${username}.home = "/home/${username}";

  system.stateVersion = "24.05";
}
