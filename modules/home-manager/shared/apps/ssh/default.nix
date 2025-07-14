{
  config,
  vars,
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
      if (vars.system != "aarch64-darwin") then
        {
          "github.com" = {
            hostname = "github.com";
            user = "bfpimentel";
            identityFile = "${home}/.ssh/id_personal";
          };
        }
      else
        {
          "github.com" = {
            hostname = "github.com";
            user = "bfpimentel";
            identityFile = "${home}/.ssh/id_personal";
          };
          "malenia" = {
            hostname = vars.maleniaIp;
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "miquella" = {
            hostname = vars.miquellaIp;
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
        };
  };
}
