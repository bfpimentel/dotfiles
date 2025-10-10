{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.gaming;

in
{
  options.bfmp.services.gaming = {
    enable = mkEnableOption "Enable Gaming Services";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   lutris
    #   shadps4
    # ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
