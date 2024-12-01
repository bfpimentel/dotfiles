let
  bruno = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANlcb4fXObPYgNu1Yo805CTCc/6IIdVgHidClVWWBoK hello@bruno.so";

  allKeys = [
    bruno
    system
  ];
in
{
  "share.age".publicKeys = allKeys;
  "cloudflare.age".publicKeys = allKeys;

  "sonarr.age".publicKeys = allKeys;
  "radarr.age".publicKeys = allKeys;
  "readarr.age".publicKeys = allKeys;
  "bazarr.age".publicKeys = allKeys;
  "prowlarr.age".publicKeys = allKeys;
  "vaultwarden.age".publicKeys = allKeys;
  "immich.age".publicKeys = allKeys;
  "audiobookshelf.age".publicKeys = allKeys;
  "plex.age".publicKeys = allKeys;
  "freshrss.age".publicKeys = allKeys;
  "speedtest-tracker.age".publicKeys = allKeys;
  "authentik.age".publicKeys = allKeys;
  "ntfy.age".publicKeys = allKeys;
  "wordpress.age".publicKeys = allKeys;
  "jellyfin.age".publicKeys = allKeys;
  "ollama-webui.age".publicKeys = allKeys;
  "paperless.age".publicKeys = allKeys;

  "tailscale/servers.age".publicKeys = allKeys;

  "restic/env.age".publicKeys = allKeys;
  "restic/repo-photos.age".publicKeys = allKeys;
  "restic/password-photos.age".publicKeys = allKeys;
  "restic/repo-containers.age".publicKeys = allKeys;
  "restic/password-containers.age".publicKeys = allKeys;

  "nginx/vault.age".publicKeys = allKeys;
  "nginx/baikal.age".publicKeys = allKeys;
}
