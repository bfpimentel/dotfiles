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
  };
}
