{ ... }:

{
  imports = [
    ./beszel
  ];

  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  networking.firewall.interfaces."docker+".allowedUDPPorts = [
    53
    5353
  ];
}
