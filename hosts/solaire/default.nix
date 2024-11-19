{ username, pkgs, ... }:

{
  imports = [
    ./services
  ];

  nix.package = pkgs.nix;

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;

  networking = {
    hostName = "solaire";
    localHostName = "solaire";
  };

  users.users.${username}.home = "/Users/${username}";

  system.stateVersion = 4;
}
