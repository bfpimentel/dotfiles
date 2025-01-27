{
  vars,
  pkgs,
  ...
}:

{
  imports = [
    ./containers
    ./services
    ./filesystems.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./nvidia.nix
    ./users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${vars.defaultUser}.home = "/home/${vars.defaultUser}";

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.space-mono
  ];

  system.stateVersion = "24.05";
}
