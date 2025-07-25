# This works for already existing .age files. Agenix isn't able to generate new ones since
# the keys need to be defined beforehand.
# let
#   # files =
#   #   builtins.readDir ./.
#   #   |> builtins.filter (fileName: builtins.match ".*\\.age" fileName != null)
#   #   |> builtins.map (name: name);
#
#   files = builtins.attrNames (builtins.readDir ./.);
#   filteredFiles = builtins.filter (fileName: builtins.match ".*\\.age" fileName != null) files;
# in
# filteredFiles
[
  "apprise.age"
  "audiobookshelf.age"
  "authentik.age"
  "bazarr.age"
  "beszel.age"
  "cloudflare.age"
  "dawarich.age"
  "freshrss.age"
  "hoarder.age"
  "immich.age"
  "jellyfin.age"
  "ollama-webui.age"
  "papra.age"
  "prowlarr.age"
  "radarr.age"
  "restic-aws-containers-password.age"
  "restic-aws-containers-repo.age"
  "restic-aws-env.age"
  "restic-aws-photos-password.age"
  "restic-aws-photos-repo.age"
  "share.age"
  "sonarr.age"
  "speedtest-tracker.age"
  "tailscale-servers.age"
  "telegram.age"
  "tinyauth.age"
  "traefik-auth.age"
  "vaultwarden.age"
  "wireguard-malenia.age"
  "wireguard-miquella.age"
]
