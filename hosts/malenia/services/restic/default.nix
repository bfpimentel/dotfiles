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
      }
      //
        genAttrs
          [
            "photos"
            "containers"
          ]
          (name: {
            requires = [ "restic-backups-podman-stop.service" ];
            after = [ "restic-backups-podman-stop.service" ];
            onFailure = [
              "restic-backups-podman-start.service"
              "restic-backups-${name}-failure.service"
            ];
            onSuccess = [
              "restic-backups-podman-start.service"
              "restic-backups-${name}-success.service"
            ];
          })
      //
        getAttrs
          [
            {
              name = "photos-failure";
              message = "Photos backup failure!";
            }
            {
              name = "photos-success";
              message = "Photos backup success!";
            }
            {
              name = "containers-failure";
              message = "Containers backup failure!";
            }
            {
              name = "containers-success";
              message = "Containers backup success!";
            }
          ]
          (
            { name, message }:
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
          );

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
