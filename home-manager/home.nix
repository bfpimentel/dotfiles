{ hostname, username, ... }:

{
  imports = [
    (./. + "/hosts/${hostname}")
    (./. + "/users/${username}.nix")
    ../modules/home-manager
  ];

  programs.home-manager.enable = true;

  home = {
    username = username;
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };
}
