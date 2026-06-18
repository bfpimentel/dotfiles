{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/n8n 0755 1000 1000 -"
          "d /mnt/mass/containers/n8n/data 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.n8n = {
          image = "n8nio/n8n:latest";
          pull = "always";
          autoStart = true;
          environment = {
            TZ = "America/Sao_Paulo";
            GENERIC_TIMEZONE = "America/Sao_Paulo";
            N8N_EDITOR_BASE_URL = "https://n8n.local.jalotopimentel.com";
            N8N_HOST = "n8n.local.jalotopimentel.com";
            N8N_PORT = "5678";
            N8N_PROTOCOL = "https";
            WEBHOOK_URL = "https://n8n.local.jalotopimentel.com";
          };
          environmentFiles = [ config.age.secrets.n8n-env.path ];
          ports = [ "5678:5678" ];
          volumes = [
            "/mnt/mass/containers/n8n/data:/home/node/.n8n"
          ];
          labels = {
            "shady.name" = "n8n";
            "shady.url" = "https://n8n.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
