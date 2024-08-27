{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
