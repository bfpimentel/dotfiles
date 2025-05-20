{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.displayManager;
in
{
  options.bfmp.services.displayManager = {
    enable = mkEnableOption "Enable DisplayManager";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.space-mono
    ];

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    services.desktopManager.plasma6.enable = true;

    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = vars.defaultUser;
      };
    };

    # systemd.services = {
    #   "@getty@tty1".enable = false;
    #   "@autovt@tty1".enable = false;
    # };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      elisa
    ];
  };
}
