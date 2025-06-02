{
  pkgs,
  config,
  lib,
  vars,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.steam;
in
{
  options.bfmp.services.steam = {
    enable = mkEnableOption "Enable Steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    systemd.user.services.steam = {
      enable = true;
      description = "Autostart Steam after Login";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent %U";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
