{ ... }:

{
  config.bfmp.hm.sharedModules = [
    (
      {
        config,
        ...
      }:
      let
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
            "*" = {
              addKeysToAgent = "yes";
              serverAliveInterval = 25;
              forwardAgent = true;
            };
          };
        };
      }
    )
  ];

  config.bfmp.hm.hosts.seraphim.modules = [
    (
      { config, ... }:
      let
        home = config.home.homeDirectory;
      in
      {
        programs.ssh.matchBlocks = {
          "virtues" = {
            hostname = "10.22.4.3";
            user = "root";
            identityFile = "${home}/.ssh/id_personal";
          };
          "dominions" = {
            hostname = "10.22.4.4";
            user = "root";
            identityFile = "${home}/.ssh/id_personal";
            setEnv.TERM = "xterm";
          };
          "powers" = {
            hostname = "10.22.4.6";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "cherubim" = {
            hostname = "10.22.4.10";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
          "thronos" = {
            hostname = "159.112.184.83";
            user = "bruno";
            identityFile = "${home}/.ssh/id_personal";
          };
        };
      }
    )
  ];
}
