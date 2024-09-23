{
  username,
  vars,
  config,
  ...
}:

let
  authentikPath = "${vars.containersConfigRoot}/authentik";
  authentikPostgresPath = "${authentikPath}/db";

  directories = [
    "${authentikPath}"
    "${authentikPath}/media"
    "${authentikPath}/templates"
    "${authentikPath}/certs"
    "${authentikPath}/redis"
  ];
in
{
  systemd.tmpfiles.rules =
    map (x: "d ${x} 0775 ${username} ${username} - -") directories
    ++ map (x: "d ${x} 0775 postgres ${username} - -") [ authentikPostgresPath ];

  systemd.services = {
    podman-authentik-server = {
      requires = [
        "podman-authentik-db.service"
        "podman-authentik-redis.service"
      ];
      after = [
        "podman-authentik-db.service"
        "podman-authentik-redis.service"
      ];
    };
    podman-authentik-worker = {
      requires = [
        "podman-authentik-db.service"
        "podman-authentik-redis.service"
      ];
      after = [
        "podman-authentik-db.service"
        "podman-authentik-redis.service"
      ];
    };
  };

  virtualisation.oci-containers = {
    containers = {
      authentik-server = {
        image = "ghcr.io/goauthentik/server:latest";
        autoStart = true;
        cmd = [ "server" ];
        volumes = [
          "${authentikPath}/media:/media"
          "${authentikPath}/templates:/templates"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          AUTHENTIK_REDIS__HOST = "authentik-redis";
          AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.authentik.rule" = "Host(`auth.${vars.domain}`)";
          "traefik.http.routers.authentik.entryPoints" = "https";
          "traefik.http.services.authentik.loadbalancer.server.port" = "9000";
          # Homepage
          "homepage.group" = "Auth";
          "homepage.name" = "Authentik";
          "homepage.icon" = "authentik.png";
          "homepage.href" = "https://auth.${vars.domain}";
        };
      };
      authentik-worker = {
        image = "ghcr.io/goauthentik/server:latest";
        autoStart = true;
        cmd = [ "worker" ];
        volumes = [
          "${authentikPath}/media:/media"
          "${authentikPath}/templates:/templates"
          "${authentikPath}/certs:/certs"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          AUTHENTIK_REDIS__HOST = "authentik-redis";
          AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
          AUTHENTIK_POSTGRESQL__USER = "authentik";
          AUTHENTIK_POSTGRESQL__NAME = "authentik";
        };
      };
      authentik-db = {
        image = "docker.io/library/postgres:12-alpine";
        autoStart = true;
        volumes = [
          "${authentikPostgresPath}:/var/lib/postgresql/data"
        ];
        environmentFiles = [ config.age.secrets.authentik.path ];
        environment = {
          POSTGRES_USER = "authentik";
          POSTGRES_DB = "authentik";
        };
      };
      authentik-redis = {
        image = "docker.io/library/redis:alpine";
        autoStart = true;
        # extraOptions = [
        #   "--save 60 1"
        #   "--loglevel warning"
        # ];
        volumes = [
          "${authentikPath}/redis:/data"
        ];
      };
    };
  };
}
