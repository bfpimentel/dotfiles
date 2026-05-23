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
          settings = {
            "github.com" = {
              HostName = "github.com";
              User = "bfpimentel";
              IdentityFile = "${home}/.ssh/id_personal";
            };
            "*" = {
              AddKeysToAgent = "yes";
              ServerAliveInterval = 25;
              ForwardAgent = true;
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
        programs.ssh.settings = {
          "virtues" = {
            HostName = "10.22.4.3";
            User = "root";
            IdentityFile = "${home}/.ssh/id_personal";
          };
          "dominions" = {
            HostName = "10.22.4.4";
            User = "root";
            IdentityFile = "${home}/.ssh/id_personal";
            SetEnv.TERM = "xterm";
          };
          "powers" = {
            HostName = "10.22.4.6";
            User = "bruno";
            IdentityFile = "${home}/.ssh/id_personal";
          };
          "cherubim" = {
            HostName = "10.22.4.10";
            User = "bruno";
            IdentityFile = "${home}/.ssh/id_personal";
          };
          "thronos" = {
            HostName = "159.112.184.83";
            User = "bruno";
            IdentityFile = "${home}/.ssh/id_personal";
          };
        };
      }
    )
  ];
}
