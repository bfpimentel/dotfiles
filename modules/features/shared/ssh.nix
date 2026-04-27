{ ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      {
        config,
        util,
        ...
      }:
      let
        inherit (util) osSpecific;
        home = config.home.homeDirectory;
      in
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "github.com" = {
              hostname = "github.com";
              user = "bfpimentel";
              identityFile = "${home}/.ssh/id_personal";
            };
            "miquella" = {
              hostname = "159.112.184.83";
              user = "bruno";
              identityFile = "${home}/.ssh/id_personal";
            };
            "godwyn" = {
              hostname = "10.22.4.4";
              user = "root";
              identityFile = "${home}/.ssh/id_personal";
            };
            "*" = {
              addKeysToAgent = "yes";
              serverAliveInterval = 25;
              forwardAgent = true;
            };
          }
          // osSpecific {
            darwin = {
              "cherubim" = {
                hostname = "10.22.4.10";
                user = "bruno";
                identityFile = "${home}/.ssh/id_personal";
              };
            };
          };
        };
      }
    )
  ];
}
