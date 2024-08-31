{ ... }:

{
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    useDHCP = false;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
