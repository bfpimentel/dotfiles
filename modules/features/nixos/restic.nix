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
        services.restic.backups.${backupName} = {
          initialize = false;
          environmentFile = config.age.secrets.restic-env.path;
          passwordFile = config.age.secrets.restic-password.path;

          paths = [
            "containers"
            "homeassistant"
            "photos"
          ];

          timerConfig = {
            OnCalendar = "*-*-* 03:00:00";
            Persistent = true;
          };

          pruneOpts = [
            "--keep-last 7"
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
