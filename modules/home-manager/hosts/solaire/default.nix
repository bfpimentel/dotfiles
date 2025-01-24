{ inputs, ... }:

{
  imports = [
    inputs.textfox.homeManagerModules.default
    ./aerospace
    ./ghostty
    ./sketchybar
    ./textfox
  ];
}
