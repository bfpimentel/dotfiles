{ ... }:

{
  imports = [
    ./services
    ./age.nix
    ./locale.nix
    ./networking.nix
    ./pkgs.nix
    ./system.nix
    ./users.nix
  ];

  nix.settings.download-buffer-size = 524288000;
}
