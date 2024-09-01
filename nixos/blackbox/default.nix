{
  hostname,
  username,
  vars,
  ...
}:

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

  networking = {
    hostName = "${hostname}";
    defaultGateway = "10.22.4.1";
    interfaces = {
      enp6s18.ipv4.addresses = [
        {
          address = vars.ip;
          prefixLength = 24;
        }
      ];
    };
    firewall = {
      enable = true;
      trustedInterfaces = [ "enp6s18" "podman0" ];
      checkReversePath = false;
    };
  };

  users.users.${username}.home = "/home/${username}";

  system.stateVersion = "24.05";
}
