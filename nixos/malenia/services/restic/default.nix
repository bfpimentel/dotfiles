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
  services.restic.backups = {
    photos = {
      initialize = true;

      environmentFile = config.age.secrets.restic-env.path;
      repositoryFile = config.age.secrets.restic-repo-photos.path;
      passwordFile = config.age.secrets.restic-password-photos.path;

      paths = [ vars.photosMountLocation ];

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

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
      ];
    };
  };

  systemd.services =
    {
      restic-backups-photos.unitConfig = {
        OnFailure = "restic-backups-photos-failure.service";
        OnSuccess = "restic-backups-photos-success.service";
      };
      restic-backups-containers.unitConfig = {
        OnFailure = "restic-backups-containers-failure.service";
        OnSuccess = "restic-backups-containers-success.service";
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
          source ${config.age.secrets.ntfy.path} && \
          ${pkgs.curl}/bin/curl \
            -u $NTFY_TOKEN \
            -d '${message}' \
            "https://notify.luana.casa/homelab"
        '';
      }
    ) backupNotifications;
}
