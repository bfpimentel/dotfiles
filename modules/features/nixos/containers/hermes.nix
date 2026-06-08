{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/hermes 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers = {
          hermes = {
            image = "docker.io/nousresearch/hermes-agent:latest";
            pull = "always";
            autoStart = true;
            cmd = [
              "gateway"
              "run"
            ];
            ports = [
              "8642:8642"
              "9119:9119"
            ];
            environment = {
              PUID = "1000";
              PGID = "1000";
              HERMES_DASHBOARD = "1";
            };
            environmentFiles = [ config.age.secrets.hermes-env.path ];
            volumes = [
              "/mnt/mass/containers/hermes:/opt/data"
            ];
          };
        };
      }
    )
  ];
}
