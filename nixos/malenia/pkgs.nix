{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    immich-cli
    nvidia-container-toolkit
    cudatoolkit
  ];
}
