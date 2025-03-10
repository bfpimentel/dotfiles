{ vars, pkgs, ... }:

{
  imports = [
    ./services
  ];

  nix.enable = false;

  nix.package = pkgs.nix;

  nixpkgs.hostPlatform = vars.system;

  networking = {
    hostName = vars.hostname;
    localHostName = vars.hostname;
  };

  users.users.${vars.defaultUser}.home = "/Users/${vars.defaultUser}";

  system.stateVersion = 4;
}
