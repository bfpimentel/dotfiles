{
  description = "bfpimentel's dotfiles";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew = {
      url = "github:koalalorenzo/home-manager-brew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay?ref=1768b61c7e47465cac6f8488c0f4d9f0fcb0a74f";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      homebrew,
      neovim-nightly,
      ...
    }:
    let
      homeManagerSystems = [
        {
          arch = "aarch64-darwin";
          extraModules = [
            homebrew.homeManagerModules.default
            ./modules/home-manager/darwin
          ];
        }
        {
          arch = "x86_64-linux";
          extraModules = [
            ./modules/home-manager/linux
          ];
        }
      ];

      forAllHomeManagerSystems =
        f: builtins.foldl' (a: b: a // b) { } (builtins.map f homeManagerSystems);

      overlays = [
        neovim-nightly.overlays.default
      ];
    in
    {
      nixosConfigurations =
        let
          nixModule =
            { ... }:
            {
              nix = {
                settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];

                nixPath = [ "nixos-config=/home/bruno/.dotfiles" ];
              };
            };

        in
        {
          artorias = nixpkgs.lib.nixosSystem {
            modules = [
              nixModule
              ./modules/hosts/artorias
            ];
          };
        };

      homeConfigurations = forAllHomeManagerSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system.arch};
        in
        {
          "bruno" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              {
                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = overlays;
                };
              }
              ./util.nix
              ./modules/home-manager
            ]
            ++ system.extraModules;
          };
        }
      );
    };
}
