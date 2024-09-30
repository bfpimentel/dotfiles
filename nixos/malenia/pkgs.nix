{ pkgs, ... }: 

{
  environment.systemPackages = with pkgs; [
    immich-cli
    cudatoolkit
  ];
}
