{
  users = import ./users.nix;
  networking = import ./networking.nix;
  docker = import ./docker.nix;

  ssh = import ./services/ssh.nix;
  plex = import ./services/plex.nix;
}
