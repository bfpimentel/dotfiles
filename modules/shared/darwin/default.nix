{ ... }:

{
  imports = [
    ./macos.nix
    ./pkgs.nix
    ./brew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;
}
