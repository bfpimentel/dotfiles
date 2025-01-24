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
        ips = [ "10.22.10.2/24" ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard-miquella.path;
        peers = [
          {
            name = "malenia";
            publicKey = "DGIv16Ow92a2EzupVjD5K8wm9F0dicocvIuhKO9YbXQ=";
            endpoint = "vpn.luana.casa:51820";
            persistentKeepalive = 25;
            allowedIPs = [
              "10.22.10.2/32"
              "10.22.4.0/24"
            ];
          }
        ];
      };
    };
  };
}
