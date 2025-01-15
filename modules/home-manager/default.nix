{ vars, ... }:

{
  imports = [
    (./. + "/hosts/${vars.hostname}")
    (./. + "/users/${vars.defaultUser}.nix")
    ./shared
  ];

  programs.home-manager.enable = true;

  home = {
    username = vars.defaultUser;
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };
}
