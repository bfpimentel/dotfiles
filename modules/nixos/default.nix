{
  nix = import ./nix.nix;

  age = import ./age.nix;
  users = import ./users.nix;
  networking = import ./networking.nix;
  locale = import ./locale.nix;
  pkgs = import ./pkgs.nix;

  ssh = import ./services/ssh.nix;
  plex = import ./services/plex.nix;
  podman = import ./services/podman.nix;
}
