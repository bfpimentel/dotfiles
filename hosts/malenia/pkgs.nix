{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    cudatoolkit

    immich-cli
  ];
}
