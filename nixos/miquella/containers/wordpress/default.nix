{
  vars,
  username,
  config,
  ...
}:

let
  wordpressPath = "${vars.containersConfigRoot}/wordpress";

  directories = [
    "${wordpressPath}"
    "${wordpressPath}/data"
    "${wordpressPath}/db"
  ];
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") directories;

  virtualisation.oci-containers = {
    containers = {
      wordpress = {
        image = "wordpress:latest";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${wordpressPath}/data:/var/www/html" ];
        environmentFiles = [ config.age.secrets.wordpress.path ];
        environment = {
          WORDPRESS_DB_HOST = "wordpress-db";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.wordpress.rule" = "Host(`jalotopimentel.com`)";
          "traefik.http.routers.wordpress.entryPoints" = "https";
          "traefik.http.services.wordpress.loadbalancer.server.port" = "80";
        };
      };
      wordpress-db = {
        image = "mysql:8.0";
        autoStart = true;
        extraOptions = [ "--pull=newer" ];
        volumes = [ "${wordpressPath}/db:/var/lib/mysql" ];
        environmentFiles = [ config.age.secrets.wordpress.path ];
        environment = {
          MYSQL_RANDOM_ROOT_PASSWORD = "1";
        };
      };
    };
  };
}
