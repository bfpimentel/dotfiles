{ ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    (
      { config, pkgs, ... }:
      let
        backupName = "shares";
        shareAutomounts = [
          "mnt-share-containers.automount"
          "mnt-share-homeassistant.automount"
          "mnt-share-photos.automount"
        ];
      in
      {
        environment.systemPackages = with pkgs; [ restic ];

        services.restic.backups.${backupName} = {
          initialize = false;
          environmentFile = config.age.secrets.restic-env.path;
          passwordFile = config.age.secrets.restic-password.path;

          paths = [
            "containers"
            "homeassistant"
            "photos"
          ];

          exclude = [
            "containers/immich/postgres"
            "containers/nginx/letsencrypt"
          ];

          timerConfig = {
            OnCalendar = "*-*-* 03:00:00";
            Persistent = true;
          };

          pruneOpts = [
            "--keep-last 7"
            "--keep-weekly 4"
            "--keep-monthly 12"
          ];

          backupPrepareCommand = ''
            set -euo pipefail
            ${pkgs.systemd}/bin/systemctl stop 'podman-*.service'
          '';

          backupCleanupCommand = ''
            set -euo pipefail
            ${pkgs.systemd}/bin/systemctl start 'podman-*.service'
          '';
        };

        systemd.services."restic-backups-${backupName}" = {
          unitConfig = {
            Wants = shareAutomounts;
            After = shareAutomounts;
          };

          serviceConfig.WorkingDirectory = "/mnt/share";
        };
      }
    )
  ];
}
