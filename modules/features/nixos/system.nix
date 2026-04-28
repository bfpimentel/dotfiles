{ ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
    (
      { pkgs, ... }:
      {
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
          hostName = "cherubim";
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
            extraConfig.pipewire = {
              "98-crackling-fix" = {
                "context.properties" = {
                  "default.clock.quantum" = 1024;
                  "default.clock.min-quantum" = 1024;
                  "default.clock.max-quantum" = 8192;
                };
              };
            };
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
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHfTMOZqQ5tMiLG7GmhkhZrwgzpD2cPuQAuqAnG24qHw hello@bruno.so"
          ];
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ "bruno" ];
          };
        };

        time.timeZone = "America/Sao_Paulo";

        system.stateVersion = "25.11";
      }
    )
  ];
}
