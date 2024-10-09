{ ... }:

{
  services.prometheus = {
    enable = true;
    port = 9001;
    # extraFlags = [ "--web.enable-admin-api" ];
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      9001
      9002
    ];
    allowedTCPPorts = [
      9001
      9002
    ];
  };
}
