{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = "Bruno Pimentel";
    userEmail = "hello@bruno.so";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "bfpimentel";
        identityFile = "/home/bruno/.ssh/id_personal";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
