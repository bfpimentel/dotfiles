{
  config,
  libs,
  pkgs,
  ...
}:

{
  imports = [
    ./traefik.nix
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };

  networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
}
