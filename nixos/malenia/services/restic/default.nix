{ config, vars, ... }:

{
  services.restic.backups = {
    photos-daily = {
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
    containers-daily = {
      initialize = true;

      environmentFile = config.age.secrets.restic-env.path;
      repositoryFile = config.age.secrets.restic-repo-containers.path;
      passwordFile = config.age.secrets.restic-password-containers.path;

      paths = [ vars.containersMountLocation ];

      # exclude = [
      #   "${vars.containersMountLocation}/immich/machine-learning"
      # ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
      ];
    };
  };
}
