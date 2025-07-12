{
  config,
  lib,
  vars,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.restic;
in
{
  options.bfmp.services.restic = {
    enable = mkEnableOption "Enable Restic Backups";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      restic
    ];

    systemd.services =
      let
        dockerBin = "${pkgs.docker}/bin/docker";
      in
      {
        restic-backups-docker-stop = {
          enable = true;
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''${dockerBin} stop $(${dockerBin} ps -a -q)'';
        };

        restic-backups-docker-start = {
          enable = true;
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''${dockerBin} start $(${dockerBin} ps -a -q)'';
        };
      }
      //
        genAttrs
          [
            "restic-backups-photos"
            "restic-backups-containers"
          ]
          (name: {
            requires = [ "restic-backups-docker-stop.service" ];
            after = [ "restic-backups-docker-stop.service" ];
            onFailure = [
              "restic-backups-docker-start.service"
              "${name}-failure.service"
            ];
            onSuccess = [
              "restic-backups-docker-start.service"
              "${name}-success.service"
            ];
          })
      //
        mapAttrs'
          (
            name: message:
            attrsets.nameValuePair "restic-backups-${name}" {
              enable = true;
              serviceConfig = {
                Type = "oneshot";
                User = vars.defaultUser;
              };
              script = ''
                sleep 60
                ${pkgs.apprise}/bin/apprise --config=${config.age.secrets.apprise.path} \
                  --tag="telegram" \
                  --title="🖥️ Server" \
                  --body="${message}"
              '';
            }
          )
          {
            photos-failure = "Photos backup failure!";
            photos-success = "Photos backup success!";
            containers-failure = "Containers backup failure!";
            containers-success = "Containers backup success!";
          };

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
  };
}
