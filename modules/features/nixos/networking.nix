{ ... }:

{
  config.bfmp.nixos.sharedModules = [
    (
      { pkgs, ... }:
      {
        networking = {
          enableIPv6 = false;
          useDHCP = false;
          networkmanager.enable = false;
        };

        systemd.network.enable = true;
      }
    )
  ];

  config.bfmp.nixos.hosts.cherubim.modules = [
    (
      { pkgs, ... }:
      {
        networking = {
          hostName = "cherubim";
          firewall.enable = false;
        };

        systemd.network.networks."10-default" = {
          matchConfig.Name = "enp5s0";
          address = [ "10.22.4.10/24" ];
          routes = [ { Gateway = "10.22.4.1"; } ];
          networkConfig = {
            DHCP = "no";
            DNS = [
              "1.1.1.1"
              "8.8.8.8"
            ];
          };
        };
      }
    )
  ];

  config.bfmp.nixos.hosts.thronos.modules = [
    (
      { ... }:
      {
        networking = {
          hostName = "thronos";
          firewall = {
            enable = true;
            allowedTCPPorts = [
              22
              80
              443
            ];
            allowedUDPPorts = [
              53
              1194
            ];
          };
        };

        systemd.network.networks."10-default" = {
          matchConfig.Name = "enp0s6";
          address = [ "10.0.0.57/24" ];
          routes = [ { Gateway = "10.0.0.1"; } ];
          networkConfig = {
            DHCP = "no";
            DNS = [
              "1.1.1.1"
              "8.8.8.8"
            ];
          };
        };

        boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
      }
    )
  ];
}
