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
  "bazarr.age".publicKeys = allKeys;
  "vaultwarden.age".publicKeys = allKeys;
  "immich.age".publicKeys = allKeys;
  "plex.age".publicKeys = allKeys;
  "tailscale-blackbox.age".publicKeys = allKeys;
  "speedtest-tracker.age".publicKeys = allKeys;
}
