{
  config,
  libs,
  pkgs,
  ...
}:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
}
