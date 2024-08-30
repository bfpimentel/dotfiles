{ username, ... }:

{
  imports = [ ../modules/home-manager ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
