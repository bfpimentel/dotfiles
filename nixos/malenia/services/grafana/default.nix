{
  vars,
  hostname,
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

  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = hostname;
        static_configs = [ { targets = [ "${vars.ip}:9002" ]; } ];
      }
      {
        job_name = "godwyn";
        static_configs = [ { targets = [ "${vars.unraidIp}:9100" ]; } ];
      }
    ];
  };

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
