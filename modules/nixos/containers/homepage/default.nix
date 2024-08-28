{
  config,
  vars,
  pkgs,
  ...
}:
let
  directories = [
    "${vars.containersConfigRoot}/homepage"
    "${vars.containersConfigRoot}/homepage/config"
  ];

  settingsFormat = pkgs.formats.yaml { };
  homepageSettings = {
    docker = settingsFormat.generate "docker.yaml" (import ./config/docker.nix);
    services = settingsFormat.generate "services.yaml" (import ./config/services.nix);
    bookmarks = settingsFormat.generate "bookmarks.yaml" (import ./config/bookmarks.nix);
    widgets = settingsFormat.generate "widgets.yaml" (import ./config/widgets.nix);
    css = pkgs.writeTextFile {
      name = "custom.css";
      text = builtins.readFile ./config/custom.css;
    };
  };
in
{
  environment.systemPackages = with pkgs; [ glances ];

  networking.firewall.allowedTCPPorts = [ 61208 ];

  systemd.services.glances = {
    description = "Glances";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.glances}/bin/glances -w";
      Type = "simple";
    };
  };

  systemd.tmpfiles.rules = map (x: "d ${x} 0775 share share - -") directories;
  virtualisation.oci-containers = {
    containers = {
      homepage = {
        image = "ghcr.io/gethomepage/homepage:latest";
        autoStart = true;
        extraOptions = [
          "--pull=newer"
          "-l=traefik.enable=true"
          "-l=traefik.http.routers.home.rule=Host(`home.${vars.domainName}`)"
          "-l=traefik.http.services.home.loadbalancer.server.port=3000"
        ];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${vars.serviceConfigRoot}/homepage:/app/config"
          "${homepageSettings.docker}:/app/config/docker.yaml"
          "${homepageSettings.bookmarks}:/app/config/bookmarks.yaml"
          "${homepageSettings.services}:/app/config/services.yaml"
          "${homepageSettings.settings}:/app/config/settings.yaml"
          "${homepageSettings.widgets}:/app/config/widgets.yaml"
          "${homepageSettings.css}:/app/config/custom.css"
          # "${config.age.secrets.sonarrApiKey.path}:/app/config/sonarr.key"
          # "${config.age.secrets.radarrApiKey.path}:/app/config/radarr.key"
          # "${config.age.secrets.jellyfinApiKey.path}:/app/config/jellyfin.key"
        ];
        environment = {
          TZ = vars.timeZone;
          # HOMEPAGE_FILE_SONARR_KEY = "/app/config/sonarr.key";
          # HOMEPAGE_FILE_RADARR_KEY = "/app/config/radarr.key";
          # HOMEPAGE_FILE_JELLYFIN_KEY = "/app/config/jellyfin.key";
        };
        # environmentFiles = [ config.age.secrets.paperless.path ];
      };
    };
  };
}
