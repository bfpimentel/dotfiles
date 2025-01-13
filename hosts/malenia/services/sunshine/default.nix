{
  pkgs,
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.programs.sunshine;

  configFile = pkgs.writeTextDir "config/sunshine.conf" ''
    origin_web_ui_allowed=wan,wg0
  '';

  sunshinePkg =
    (pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.cudaPackages.cuda_nvcc
          (lib.getDev pkgs.cudaPackages.cuda_cudart)
        ];
        cmakeFlags = old.cmakeFlags ++ [
          "-DCMAKE_CUDA_COMPILER=${(lib.getExe pkgs.cudaPackages.cuda_nvcc)}"
        ];
      });
in
{
  options.programs.sunshine = with lib; {
    enable = mkEnableOption "sunshine";
  };

  config = lib.mkIf cfg.enable {
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;
    services.udisks2.enable = lib.mkForce false;

    boot.kernelModules = [ "uinput" ];

    programs.steam.enable = true;

    # security.wrappers.sunshine = {
    #   owner = "root";
    #   group = "root";
    #   capabilities = "cap_sys_admin+p";
    #   source = "${sunshinePkg}/bin/sunshine";
    # };

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
