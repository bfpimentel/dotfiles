{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];
}
