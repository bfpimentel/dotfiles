{
  vars,
  username,
  lib,
  ...
}:

let
  grafanaPath = "${vars.servicesConfigRoot}/grafana";

  directories = [ grafanaPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  systemd.services.grafana.serviceConfig = {
    User = lib.mkDefault username;
    Group = lib.mkDefault username;
  };

  services.grafana = {
    enable = true;
    dataDir = grafanaPath;
    settings.server = {
      domain = "grafana.${vars.domain}";
      http_addr = "${vars.ip}";
      http_port = 2342;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "node-exporter";
      static_configs = [
        {
          targets = [
            "${vars.ip}:9002"
            "${vars.miquellaIp}:9002"
            "${vars.godwynIp}:9100"
          ];
        }
      ];
    }
  ];

  networking.firewall = {
    allowedUDPPorts = [
      2342
      9001
      9002
    ];
    allowedTCPPorts = [
      2342
      9001
      9002
    ];
  };
}
