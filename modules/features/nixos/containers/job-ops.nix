{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { ... }:
      {
        systemd.tmpfiles.rules = [
          "d /mnt/mass/containers/job-ops 0755 1000 1000 -"
          "d /mnt/mass/containers/job-ops/data 0755 1000 1000 -"
          "d /mnt/mass/containers/job-ops/codex 0755 1000 1000 -"
        ];

        virtualisation.oci-containers.containers.job-ops = {
          image = "ghcr.io/dakheera47/job-ops:latest";
          pull = "always";
          autoStart = true;
          ports = [ "3005:3001" ];
          environment = {
            NODE_ENV = "production";
            PORT = "3001";
            CODEX_HOME = "/app/codex-home";
            JOBOPS_PUBLIC_BASE_URL = "https://jobs.local.jalotopimentel.com";
          };
          volumes = [
            "/mnt/mass/containers/job-ops/data:/app/data"
            "/mnt/mass/containers/job-ops/codex:/app/codex-home"
          ];
          labels = {
            "shady.name" = "job-ops";
            "shady.url" = "https://jobs.local.jalotopimentel.com";
          };
        };
      }
    )
  ];
}
