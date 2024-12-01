{ username, vars, ... }:

let
  baikalPaths =
    let
      root = "${vars.containersConfigRoot}/baikal";
    in
    {
      inherit root;
      data = "${root}/data";
      config = "${root}/config";
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${username} ${username} - -") (
    builtins.attrValues baikalPaths
  );

  virtualisation.oci-containers.containers = {
    baikal = {
      image = "ckulka/baikal:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      ports = [ "9040:80" ];
      volumes = [
        "${baikalPaths.data}:/var/www/baikal/Specific"
        "${baikalPaths.config}:/var/www/baikal/config"
      ];
      labels = {
        # Homepage
        "homepage.group" = "Documents";
        "homepage.name" = "Baikal";
        "homepage.icon" = "baikal.png";
        "homepage.href" = "https://baikal.${vars.externalDomain}";
      };
    };
  };
}
