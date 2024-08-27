{ config, libs, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = "blackbox";
    enableIPv6 = false;
    useDHCP = false;
    interfaces = {
      enp6s18.ipv4.addresses = [{
	address = "10.22.4.20";
	prefixLength = 24;
      }];
    };
    defaultGateway = "10.22.4.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };
}
