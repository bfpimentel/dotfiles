{ inputs, ... }:

{
  imports = [
    inputs.textfox.homeManagerModules.default
  ];

  textfox = {
    enable = true;
    profile = "Bruno";
  };
}
