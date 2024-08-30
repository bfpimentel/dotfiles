{
  nix = import ./nix.nix;

  age = import ./age.nix;
  users = import ./users.nix;
  networking = import ./networking.nix;
  locale = import ./locale.nix;
  pkgs = import ./pkgs.nix;

  # services
  ssh = import ./services/ssh.nix;
  plex = import ./services/plex.nix;
  glances = import ./services/glances.nix;

  # containers
  podman = import ./podman.nix;
  traefik = import ./containers/traefik;
  homepage = import ./containers/homepage;
  dozzle = import ./containers/dozzle;
}
