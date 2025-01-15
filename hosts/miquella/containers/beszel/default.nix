{
  config,
  vars,
  ...
}:
let
  beszelPaths =
    let
      root = "${vars.containersConfigRoot}/beszel";
    in
    {
      volumes = {
        inherit root;
      };
    };
in
{
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 ${vars.defaultUser} ${vars.defaultUser} - -") (
    builtins.attrValues beszelPaths.volumes
  );

  networking.firewall = {
    allowedTCPPorts = [ 45876 ];
  };

  virtualisation.oci-containers.containers = {
    beszel-agent = {
      image = "henrygd/beszel-agent:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      ports = [ "45876:45876" ];
      volumes = [ "/var/run/podman/podman.sock:/var/run/docker.sock" ];
      environment = {
        PORT = "45876";
        KEY = builtins.readFile config.age.secrets.beszel.path; # need to use anti-pattern here.
      };
    };
  };
}
