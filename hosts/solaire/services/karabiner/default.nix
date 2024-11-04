{ inputs, ... }:

{
  services.karabiner-elements = {
    enable = true;
    package = inputs.nixpkgs-stable.legacyPackages.aarch64-darwin.karabiner-elements;
  };
}
