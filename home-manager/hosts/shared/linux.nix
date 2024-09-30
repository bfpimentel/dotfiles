{ username, ... }:

{
  imports = [
    ./zsh
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "bfpimentel";
        identityFile = "/home/${username}/.ssh/id_personal";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
