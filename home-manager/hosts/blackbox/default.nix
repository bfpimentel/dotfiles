{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github" = {
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
