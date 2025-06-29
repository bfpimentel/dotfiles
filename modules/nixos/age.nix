{ vars, ... }:

let
  username = vars.defaultUser;

  mkSecret = filePath: {
    file = filePath;
    mode = "600";
    owner = vars.defaultUser;
    group = vars.defaultUser;
  };
in
{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_personal" ];

    secrets = {
      share = mkSecret ../../secrets/share.age;
      cloudflare = mkSecret ../../secrets/cloudflare.age;
      radarr = mkSecret ../../secrets/radarr.age;
      sonarr = mkSecret ../../secrets/sonarr.age;
      bazarr = mkSecret ../../secrets/bazarr.age;
      prowlarr = mkSecret ../../secrets/prowlarr.age;
      vaultwarden = mkSecret ../../secrets/vaultwarden.age;
      immich = mkSecret ../../secrets/immich.age;
      audiobookshelf = mkSecret ../../secrets/audiobookshelf.age;
      plex = mkSecret ../../secrets/plex.age;
      freshrss = mkSecret ../../secrets/freshrss.age;
      speedtest-tracker = mkSecret ../../secrets/speedtest-tracker.age;
      authentik = mkSecret ../../secrets/authentik.age;
      wordpress = mkSecret ../../secrets/wordpress.age;
      jellyfin = mkSecret ../../secrets/jellyfin.age;
      ollama-webui = mkSecret ../../secrets/ollama-webui.age;
      paperless = mkSecret ../../secrets/paperless.age;
      beszel = mkSecret ../../secrets/beszel.age;
      hoarder = mkSecret ../../secrets/hoarder.age;
      aliasvault = mkSecret ../../secrets/aliasvault.age;
      apprise = mkSecret ../../secrets/apprise.age;
      ntfy = mkSecret ../../secrets/ntfy.age;
      telegram = mkSecret ../../secrets/telegram.age;
      traefik-auth = mkSecret ../../secrets/traefik/auth.age;
      tailscale-servers = mkSecret ../../secrets/tailscale/servers.age;
      restic-env = mkSecret ../../secrets/restic/env.age;
      restic-repo-containers = mkSecret ../../secrets/restic/repo-containers.age;
      restic-password-containers = mkSecret ../../secrets/restic/password-containers.age;
      restic-repo-photos = mkSecret ../../secrets/restic/repo-photos.age;
      restic-password-photos = mkSecret ../../secrets/restic/password-photos.age;
      nginx-vault = mkSecret ../../secrets/nginx/vault.age;
      nginx-baikal = mkSecret ../../secrets/nginx/baikal.age;
      wireguard-miquella = mkSecret ../../secrets/wireguard/miquella.age;
      wireguard-malenia = mkSecret ../../secrets/wireguard/malenia.age;
    };
  };
}
