{
  system = import ./system.nix;
  macos = import ./macos.nix;
  pkgs = import ./pkgs.nix;
  brew = import ./brew.nix;
}
