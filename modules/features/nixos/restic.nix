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
          ];

          backupPrepareCommand = ''
            set -euo pipefail

            units_file="$RUNTIME_DIRECTORY/podman-units"
            ${pkgs.systemd}/bin/systemctl list-units 'podman-*.service' --state=active --plain --no-legend \
              | ${pkgs.gawk}/bin/awk '{print $1}' > "$units_file"

            if [ -s "$units_file" ]; then
              ${pkgs.systemd}/bin/systemctl stop $(cat "$units_file")
            fi
          '';

          backupCleanupCommand = ''
            set -euo pipefail

            units_file="$RUNTIME_DIRECTORY/podman-units"
            if [ -s "$units_file" ]; then
              ${pkgs.systemd}/bin/systemctl start $(cat "$units_file")
            fi
          '';
        };

        systemd.services."restic-backups-${backupName}" = {
          unitConfig = {
            Wants = shareAutomounts;
            After = shareAutomounts;
          };

          serviceConfig = {
            WorkingDirectory = "/mnt/share";
            RuntimeDirectory = "restic-backups-${backupName}";
          };
        };
      }
    )
  ];
}
