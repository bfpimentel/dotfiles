{
  config,
  vars,
  username,
  pkgs,
  lib,
  ...
}:

let
  backupNotifications = {
    restic-backups-photos-failure = "Photos backup failure!";
    restic-backups-photos-success = "Photos backup success!";
    restic-backups-containers-failure = "Containers backup failure!";
    restic-backups-containers-success = "Containers backup success!";
  };
in
{
  systemd.services =
    {
      restic-backups-podman-stop = {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''${pkgs.systemd}/bin/systemctl stop podman-*'';
      };

      restic-backups-podman-start = {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''${pkgs.systemd}/bin/systemctl start --no-block --all "podman-*"'';
      };

      restic-backups-photos = {
        requires = [ "restic-backups-podman-stop.service" ];
        after = [ "restic-backups-podman-stop.service" ];
        onFailure = [
          "restic-backups-podman-start.service"
          "restic-backups-photos-failure.service"
        ];
        onSuccess = [
          "restic-backups-podman-start.service"
          "restic-backups-photos-success.service"
        ];
      };

      restic-backups-containers = {
        requires = [ "restic-backups-podman-stop.service" ];
        after = [ "restic-backups-podman-stop.service" ];
        onFailure = [
          "restic-backups-podman-start.service"
          "restic-backups-containers-failure.service"
        ];
        onSuccess = [
          "restic-backups-podman-start.service"
          "restic-backups-containers-success.service"
        ];
      };
    }
    // lib.mapAttrs' (
      name: message:
      lib.attrsets.nameValuePair name {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = username;
        };
        script = ''
          sleep 60
          source ${config.age.secrets.ntfy.path}
          ${pkgs.curl}/bin/curl \
            -u $NTFY_TOKEN \
            -d '${message}' \
            "https://notify.${vars.externalDomain}/homelab"
        '';
      }
    ) backupNotifications;

  services.restic.backups = {
    photos = {
      initialize = true;

      environmentFile = config.age.secrets.restic-env.path;
      repositoryFile = config.age.secrets.restic-repo-photos.path;
      passwordFile = config.age.secrets.restic-password-photos.path;

      paths = [ vars.photosMountLocation ];

      exclude = [
        "${vars.containersConfigRoot}/whisper"
      ];

      timerConfig = {
        OnCalendar = "04:00";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
      ];
    };
    containers = {
      initialize = true;

      environmentFile = config.age.secrets.restic-env.path;
      repositoryFile = config.age.secrets.restic-repo-containers.path;
      passwordFile = config.age.secrets.restic-password-containers.path;

      paths = [
        vars.containersConfigRoot
        vars.servicesConfigRoot
      ];

      exclude = [
        "${vars.servicesConfigRoot}/ollama/models"
      ];

      timerConfig = {
        OnCalendar = "04:00";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
      ];
    };
  };
}
