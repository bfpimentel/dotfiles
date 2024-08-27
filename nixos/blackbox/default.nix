{ inputs, outputs, lib, config, pkgs, ... }: 

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/Sao_Paulo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  console.keyMap = "us-acentos";

  fileSystems."/mnt/share" = {
    device = "//10.22.4.5/malenia-share/bruno";
    fsType = "cifs";
    options = [ "credentials=/etc/nixos/smb-credentials" "uid=2000" "gid=2000" "x-systemd.automount" "noauto" "rw" ];
  };

  system.stateVersion = "24.05"; 
}

