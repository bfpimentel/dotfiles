{ vars, pkgs, ... }:

{
  imports = [
    ./services
  ];

  nix.package = pkgs.nix;

  nixpkgs.hostPlatform = vars.system;

  services.nix-daemon.enable = true;

  networking = {
    hostName = vars.hostname;
    localHostName = vars.hostname;
  };

  users.users.${vars.defaultUser}.home = "/Users/${vars.defaultUser}";

  system.stateVersion = 4;
}
