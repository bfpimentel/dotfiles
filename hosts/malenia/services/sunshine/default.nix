{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  sunshinePkg =
    (pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.cudaPackages.cuda_nvcc
          (getDev pkgs.cudaPackages.cuda_cudart)
        ];
        cmakeFlags = old.cmakeFlags ++ [
          "-DCMAKE_CUDA_COMPILER=${(getExe pkgs.cudaPackages.cuda_nvcc)}"
        ];
      });

  cfg = config.bfmp.services.sunshine;
in
{
  options.bfmp.services.sunshine = {
    enable = mkEnableOption "Enable Sunshine";
  };

  config = mkIf cfg.enable {
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
    services.udisks2.enable = mkForce false;

    boot.kernelModules = [ "uinput" ];

    programs.steam.enable = true;

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = sunshinePkg;
    };

    systemd.user.services.sunshine = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
    };
  };
}
