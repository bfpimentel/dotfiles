{ username, ... }:

{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_personal" ];

    secrets = {
      share.file = ../../secrets/share.age;
      cloudflare.file = ../../secrets/cloudflare.age;

      sonarr.file = ../../secrets/sonarr.age;
      radarr.file = ../../secrets/radarr.age;
      readarr.file = ../../secrets/readarr.age;
      bazarr.file = ../../secrets/bazarr.age;
      prowlarr.file = ../../secrets/prowlarr.age;
      vaultwarden.file = ../../secrets/vaultwarden.age;
      immich.file = ../../secrets/immich.age;
      audiobookshelf.file = ../../secrets/audiobookshelf.age;
      plex.file = ../../secrets/plex.age;
      freshrss.file = ../../secrets/freshrss.age;
      speedtest-tracker.file = ../../secrets/speedtest-tracker.age;
      authentik.file = ../../secrets/authentik.age;
      wordpress.file = ../../secrets/wordpress.age;
      jellyfin.file = ../../secrets/jellyfin.age;
      ollama-webui.file = ../../secrets/ollama-webui.age;
      paperless.file = ../../secrets/paperless.age;
      ntfy = {
        file = ../../secrets/ntfy.age;
        mode = "600";
        owner = username;
        group = username;
      };

      tailscale-servers.file = ../../secrets/tailscale/servers.age;

      restic-env.file = ../../secrets/restic/env.age;
      restic-repo-containers.file = ../../secrets/restic/repo-containers.age;
      restic-password-containers.file = ../../secrets/restic/password-containers.age;
      restic-repo-photos.file = ../../secrets/restic/repo-photos.age;
      restic-password-photos.file = ../../secrets/restic/password-photos.age;

      nginx-vault = {
        file = ../../secrets/nginx/vault.age;
        mode = "600";
        owner = username;
        group = username;
      };
      nginx-baikal = {
        file = ../../secrets/nginx/baikal.age;
        mode = "600";
        owner = username;
        group = username;
      };
    };
  };
}
