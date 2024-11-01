{
  vars,
  pkgs,
  username,
  ...
}:

let
  plexPath = "${vars.servicesConfigRoot}/plex";
in
{
  systemd.services.plex.serviceConfig = {
    User = username;
    Group = username;
  };

  services.plex =
    let
      plexPassPkg = pkgs.plex.override {
        plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
          version = "1.41.1.9057-af5eaea7a";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-A4OL70fu4tWnqTc5JvUl2I7p+p8aMYWk+B5HWdlFKpQ=";
          };
        });
      };
    in
    {
      enable = true;
      openFirewall = true;
      user = username;
      group = username;
      package = plexPassPkg;
      dataDir = plexPath;
      accelerationDevices = [ "*" ];
    };
}
