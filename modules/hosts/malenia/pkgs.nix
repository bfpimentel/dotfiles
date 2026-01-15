{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    orca-slicer
    usbutils
    parted

    kitty
  ];
}
