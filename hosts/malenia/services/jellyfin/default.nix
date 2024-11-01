{
  username,
  vars,
  pkgs,
  ...
}:

let
  jellyfinPath = "${vars.servicesConfigRoot}/jellyfin";

  directories = [ jellyfinPath ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = username;
    configDir = jellyfinPath;
  };
}
