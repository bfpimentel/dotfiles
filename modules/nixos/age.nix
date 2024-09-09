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
      tailscale-blackbox.file = ../../secrets/tailscale-blackbox.age;
      speedtest-tracker.file = ../../secrets/speedtest-tracker.age;
    };
  };
}
