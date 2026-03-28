{ pkgs, ... }:

{
  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "uinput" ];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Pimentel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
  };

  networking = {
    hostName = "artorias";
    enableIPv6 = false;
    useDHCP = false;
    defaultGateway = "10.22.4.1";
    firewall.enable = false;
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    interfaces."enp5s0".ipv4.addresses = [
      {
        address = "10.22.4.10";
        prefixLength = 24;
      }
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
    extraPackages = with pkgs; [
      grim
      pulseaudio
      swayidle
      swaylock
      wmenu
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  console.useXkbConfig = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    tailscale.enable = true;
    pulseaudio.enable = false;
    avahi.publish.userServices = true;
    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
    '';
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "alt-intl";
      };
    };
  };

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

  system.stateVersion = "25.11";
}
