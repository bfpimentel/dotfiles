{ username, ... }:

{
  imports = [ ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  networking.hostName = "solaire";
  networking.localHostName = "solaire";

  users.users.${username}.home = "/Users/${username}";
}
