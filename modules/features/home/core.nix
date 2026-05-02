{ inputs, ... }:

{
  config.bfmp.hm = {
    hosts = {
      seraphim.arch = "aarch64-darwin";
      cherubim.arch = "x86_64-linux";
      powers.arch = "x86_64-linux";
      thronos.arch = "aarch64-linux";
    };

    overlays = [
      inputs.neovim-nightly.overlays.default
      (final: prev: {
        nh = inputs.nh.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  config.bfmp.hm.sharedModules = [
    (
      {
        pkgs,
        util,
        ...
      }:
      {
        home = {
          username = "bruno";
          stateVersion = "25.11";
        };

        programs.home-manager.enable = true;
      }
    )
  ];

  config.bfmp.hm.hosts.seraphim.modules = [
    (
      { util, ... }:
      {
        home.homeDirectory = "/Users/bruno";
      }
    )
  ];

  config.bfmp.hm.hosts.cherubim.modules = [
    (
      { util, ... }:
      {
        home.homeDirectory = "/home/bruno";
      }
    )
  ];

  config.bfmp.hm.hosts.powers.modules = [
    (
      { util, ... }:
      {
        home.homeDirectory = "/home/bruno";
      }
    )
  ];

  config.bfmp.hm.hosts.thronos.modules = [
    (
      { util, ... }:
      {
        home.homeDirectory = "/home/bruno";
      }
    )
  ];
}
