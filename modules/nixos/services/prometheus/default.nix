{ vars }:

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
    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [
              "${vars.ip}:9002"
              "${vars.godwynIp}:9100"
              "${vars.miquellaIp}:9100"
            ];
          }
        ];
      }
    ];
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
