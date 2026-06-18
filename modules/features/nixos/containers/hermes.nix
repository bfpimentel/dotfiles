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
            environmentFiles = [ config.age.secrets.hermes-env.path ];
            environment = {
              HERMES_DASHBOARD = "1";
            };
            volumes = [
              "/mnt/mass/containers/hermes:/opt/data"
            ];
            labels = {
              "shady.name" = "hermes";
              "shady.url" = "https://hermes.local.jalotopimentel.com";
            };
          };
        };
      }
    )
  ];
}
