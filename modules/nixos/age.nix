{ username, ... }:

{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_personal" ];

    secrets = {
      share.file = ../../secrets/share.age;
      cloudflare.file = ../../secrets/cloudflare.age;

      sonarr.file = ../../secrets/sonarr.age;
      radarr.file = ../../secrets/radarr.age;
      bazarr.file = ../../secrets/bazarr.age;
      vaultwarden.file = ../../secrets/vaultwarden.age;
      immich.file = ../../secrets/immich.age;
      plex.file = ../../secrets/plex.age;
      speedtest-tracker.file = ../../secrets/speedtest-tracker.age;
      authentik.file = ../../secrets/authentik.age;
      wordpress.file = ../../secrets/wordpress.age;
      jellyfin.file = ../../secrets/jellyfin.age;
      ntfy = {
        file = ../../secrets/ntfy.age;
        mode = "600";
        owner = username;
        group = username;
      };

      tailscale-malenia.file = ../../secrets/tailscale/malenia.age;
      tailscale-containers.file = ../../secrets/tailscale/containers.age;

      restic-env.file = ../../secrets/restic/env.age;
      restic-repo-containers.file = ../../secrets/restic/repo-containers.age;
      restic-password-containers.file = ../../secrets/restic/password-containers.age;
      restic-repo-photos.file = ../../secrets/restic/repo-photos.age;
      restic-password-photos.file = ../../secrets/restic/password-photos.age;
    };
  };
}
