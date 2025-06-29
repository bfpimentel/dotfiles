{ vars, ... }:

let
  username = vars.defaultUser;
in
{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_personal" ];

    secrets = {
      share = {
        file = ../../secrets/share.age;
        mode = "600";
        owner = username;
        group = username;
      };
      cloudflare = {
        file = ../../secrets/cloudflare.age;
        mode = "600";
        owner = username;
        group = username;
      };
      sonarr = {
        file = ../../secrets/sonarr.age;
        mode = "600";
        owner = username;
        group = username;
      };
      radarr = {
        file = ../../secrets/radarr.age;
        mode = "600";
        owner = username;
        group = username;
      };
      readarr = {
        file = ../../secrets/readarr.age;
        mode = "600";
        owner = username;
        group = username;
      };
      bazarr = {
        file = ../../secrets/bazarr.age;
        mode = "600";
        owner = username;
        group = username;
      };
      prowlarr = {
        file = ../../secrets/prowlarr.age;
        mode = "600";
        owner = username;
        group = username;
      };
      vaultwarden = {
        file = ../../secrets/vaultwarden.age;
        mode = "600";
        owner = username;
        group = username;
      };
      immich = {
        file = ../../secrets/immich.age;
        mode = "600";
        owner = username;
        group = username;
      };
      audiobookshelf = {
        file = ../../secrets/audiobookshelf.age;
        mode = "600";
        owner = username;
        group = username;
      };
      plex = {
        file = ../../secrets/plex.age;
        mode = "600";
        owner = username;
        group = username;
      };
      freshrss = {
        file = ../../secrets/freshrss.age;
        mode = "600";
        owner = username;
        group = username;
      };
      speedtest-tracker = {
        file = ../../secrets/speedtest-tracker.age;
        mode = "600";
        owner = username;
        group = username;
      };
      authentik = {
        file = ../../secrets/authentik.age;
        mode = "600";
        owner = username;
        group = username;
      };
      wordpress = {
        file = ../../secrets/wordpress.age;
        mode = "600";
        owner = username;
        group = username;
      };
      jellyfin = {
        file = ../../secrets/jellyfin.age;
        mode = "600";
        owner = username;
        group = username;
      };
      ollama-webui = {
        file = ../../secrets/ollama-webui.age;
        mode = "600";
        owner = username;
        group = username;
      };
      paperless = {
        file = ../../secrets/paperless.age;
        mode = "600";
        owner = username;
        group = username;
      };
      beszel = {
        file = ../../secrets/beszel.age;
        mode = "600";
        owner = username;
        group = username;
      };
      hoarder = {
        file = ../../secrets/hoarder.age;
        mode = "600";
        owner = username;
        group = username;
      };
      aliasvault = {
        file = ../../secrets/aliasvault.age;
        mode = "600";
        owner = username;
        group = username;
      };
      apprise = {
        file = ../../secrets/apprise.age;
        mode = "600";
        owner = username;
        group = username;
      };
      ntfy = {
        file = ../../secrets/ntfy.age;
        mode = "600";
        owner = username;
        group = username;
      };
      telegram = {
        file = ../../secrets/telegram.age;
        mode = "600";
        owner = username;
        group = username;
      };
      traefik-auth = {
        file = ../../secrets/traefik/auth.age;
        mode = "600";
        owner = username;
        group = username;
      };
      tailscale-servers = {
        file = ../../secrets/tailscale/servers.age;
        mode = "600";
        owner = username;
        group = username;
      };
      restic-env = {
        file = ../../secrets/restic/env.age;
        mode = "600";
        owner = username;
        group = username;
      };
      restic-repo-containers = {
        file = ../../secrets/restic/repo-containers.age;
        mode = "600";
        owner = username;
        group = username;
      };
      restic-password-containers = {
        file = ../../secrets/restic/password-containers.age;
        mode = "600";
        owner = username;
        group = username;
      };
      restic-repo-photos = {
        file = ../../secrets/restic/repo-photos.age;
        mode = "600";
        owner = username;
        group = username;
      };
      restic-password-photos = {
        file = ../../secrets/restic/password-photos.age;
        mode = "600";
        owner = username;
        group = username;
      };
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
      wireguard-miquella = {
        file = ../../secrets/wireguard/miquella.age;
        mode = "600";
        owner = username;
        group = username;
      };
      wireguard-malenia = {
        file = ../../secrets/wireguard/malenia.age;
        mode = "600";
        owner = username;
        group = username;
      };
    };
  };
}
