{ username, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com-personal" = {
        hostname = "github.com";
        user = "bfpimentel";
        identityFile = "/Users/${username}/.ssh/id_personal";
      };
      "github.com-owlet" = {
        hostname = "github.com";
        user = "bfpimentel-owlet";
        identityFile = "/Users/${username}/.ssh/id_owlet";
      };
      "blackbox" = {
        hostname = "10.22.4.2";
        user = "bruno";
        identityFile = "/Users/${username}/.ssh/id_personal";
      };
      "godwyn" = {
        hostname = "10.22.4.10";
        user = "bruno";
        identityFile = "/Users/${username}/.ssh/id_personal";
      };
      "miquella" = {
        hostname = "159.112.184.83";
        user = "ubuntu";
        identityFile = "/Users/${username}/.ssh/id_personal";
      };
      "spark-suited" = {
        hostname = "135.181.157.124";
        user = "spark";
        identityFile = "/Users/${username}/.ssh/id_spark_suited";
      };
    };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
