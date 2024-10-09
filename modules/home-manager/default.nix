{
  hostname,
  username,
  ...
}:

{
  imports = [
    (./. + "/hosts/${hostname}")
    (./. + "/users/${username}.nix")
    ./shared
  ];

  programs.home-manager.enable = true;

  home = {
    username = username;
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };
}
