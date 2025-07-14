{ ... }:

{
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean = {
      enable = true;
      
      extraArgs = "--keep-since 7d";
    };
  };
}
