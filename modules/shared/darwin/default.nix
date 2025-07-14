{ ... }:

{
  imports = [
    ./macos.nix
    ./pkgs.nix
    ./brew.nix
  ];
  # macos = import ./macos.nix;
  # pkgs = import ./pkgs.nix;
  # brew = import ./brew.nix;
}
