{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.bfmp.services.gaming;

  # shadps4 = pkgs.shadps4.overrideAttrs (old: rec {
  #   version = "0.7.0";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "shadps4-emu";
  #     repo = "shadPS4";
  #     tag = "v.${version}";
  #     hash = "sha256-g55Ob74Yhnnrsv9+fNA1+uTJ0H2nyH5UT4ITHnrGKDo=";
  #     fetchSubmodules = true;
  #   };
  # });
in
{
  options.bfmp.services.gaming = {
    enable = mkEnableOption "Enable Gaming Services";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      shadps4
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
