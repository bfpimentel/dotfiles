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
          version = "1.41.2.9200-c6bbc1b53";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-HmgtnUsDzRIUThYdlZIzhiU02n9jSU7wtwnEA0+r1iQ=";
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
