{ pkgs, lib, ... }:

{
  imports = [
    ./display.nix
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "uinput" ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  networking = {
    hostName = "artorias";
    enableIPv6 = false;
    useDHCP = false;
    firewall.enable = false;
    networkmanager.enable = false;
  };

  systemd.network = {
    enable = true;
    networks."10-default" = {
      matchConfig.Name = "enp5s0";
      address = [ "10.22.4.10/24" ];
      routes = [ { Gateway = "10.22.4.1"; } ];
      networkConfig = {
        DHCP = "no";
        DNS = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    pulseaudio.enable = false;
    tailscale.enable = true;
    avahi.publish.userServices = true;
    udisks2.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  nix.settings.trusted-users = [ "bruno" ];

  users.users.bruno = {
    isNormalUser = true;
    description = "Bruno Pimentel";
    extraGroups = [
      "wheel"
      "video"
      "input"
      "podman"
    ];
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

    ### Pro Micro 3V3/8MHz
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
    ### Pro Micro 5V/16MHz
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

    # hid_listen
    KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

    # hid bootloaders
    ## QMK HID
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2067", TAG+="uaccess"

    # Explorer
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="0000", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

    # Pro Micro DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", TAG+="uaccess"
  '';

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "25.11";
}
