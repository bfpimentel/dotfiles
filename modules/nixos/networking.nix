{
  config,
  libs,
  pkgs,
  ...
}:

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

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
