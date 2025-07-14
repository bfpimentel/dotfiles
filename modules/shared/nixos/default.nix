{ ... }:
{
  imports = [
    ./system.nix
    ./age.nix
    ./users.nix
    ./networking.nix
    ./locale.nix
    ./pkgs.nix
    ./services
  ];

  # system = import ./system.nix;
  #
  # age = import ./age.nix;
  # users = import ./users.nix;
  # networking = import ./networking.nix;
  # locale = import ./locale.nix;
  # pkgs = import ./pkgs.nix;
  #
  # services = import ./services;
}
