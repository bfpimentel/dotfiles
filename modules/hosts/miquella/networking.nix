{ vars, ... }:

{
  networking = {
    networkmanager.enable = false;
    nat = {
      enable = true;
      externalInterface = vars.networkInterface;
      internalInterfaces = [ vars.wireguardInterface ];
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
