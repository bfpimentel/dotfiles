{
  config,
  vars,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  programs.ssh =
    let
      systemSpecificConfig =
        if (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") then
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
          }
        else
          { };
    in
    {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          serverAliveInterval = 25;
        };
        "github.com" = {
          hostname = "github.com";
          user = "bfpimentel";
          identityFile = "${home}/.ssh/id_personal";
        };

      }
      // systemSpecificConfig;
    };
}
