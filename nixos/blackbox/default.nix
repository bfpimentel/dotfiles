{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./mounts.nix
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
          address = "10.22.4.20";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.22.4.1";
  };

  system.stateVersion = "24.05";
}
