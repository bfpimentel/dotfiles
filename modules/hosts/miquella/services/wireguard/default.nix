{
  vars,
  config,
  ...
}:

{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.wireguard = {
    enable = true;
    interfaces = {
      "${vars.wireguardInterface}" = {
        ips = [ "10.22.10.4/24" ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard-miquella.path;
        peers = [
          {
            name = "wg-lb";
            publicKey = "IY3am4h3W9erXrMnbYkTMjY68lxHMZUUL0Cfd2ucSHA=";
            endpoint = "vpn.jalotopimentel.com:51820";
            persistentKeepalive = 25;
            allowedIPs = [
              "10.22.10.4/32"
              "10.22.4.0/24"
            ];
          }
        ];
      };
    };
  };
}
