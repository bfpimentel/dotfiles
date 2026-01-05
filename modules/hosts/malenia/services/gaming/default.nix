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

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    services.udev.extraRules = ''
      KERNEL=="hidraw\*", ATTRS{idProduct}=="3109", ATTRS{idVendor}=="2dc8", MODE="0660", GROUP="input"
    '';
  };
}
