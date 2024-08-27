{
  nix = import ./nix.nix;
  users = import ./users.nix;
  networking = import ./networking.nix;
  mounts = import ./mounts.nix;
  locale = import ./locale.nix;
  pkgs = import ./pkgs.nix;

  ssh = import ./services/ssh.nix;
  plex = import ./services/plex.nix;
  docker = import ./services/docker.nix;
}
