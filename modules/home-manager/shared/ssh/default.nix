{
  system,
  config,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
      ServerAliveInterval 60
    '';
    matchBlocks =
      if (system != "aarch64-darwin") then
        {
          "github.com" = {
            hostname = "github.com";
            user = "bfpimentel";
            identityFile = "${home}/.ssh/id_personal";
          };
        }
      else
        {
          "github.com-personal" = {
            hostname = "github.com";
            user = "bfpimentel";
            identityFile = "${home}/.ssh/id_personal";
          };
          "github.com-owlet" = {
            hostname = "github.com";
            user = "bfpimentel-owlet";
            identityFile = "${home}/.ssh/id_owlet";
          };
          "malenia" = {
            hostname = "10.22.4.2";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "godwyn" = {
            hostname = "10.22.4.4";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "miquella" = {
            hostname = "159.112.184.83";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "spark-suited" = {
            hostname = "135.181.157.124";
            user = "spark";
            identityFile = "${home}/.ssh/id_spark_suited";
          };
        };
  };
}
