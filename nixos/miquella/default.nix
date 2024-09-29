# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ username, config, vars, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./networking.nix
    ./filesystems.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = vars.timeZone;

  users.users.${username}.home = "/home/${username}";

  # todo: remove
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEQfvoGzi0djr8CsbGuBR3LwHXQyd4gj5geArDwo1d5 bruno@pimentel.dev"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}

