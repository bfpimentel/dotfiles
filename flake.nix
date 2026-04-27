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
      url = "github:nix-community/neovim-nightly-overlay";
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
      hmSystems = [
        {
          hostname = "seraphim";
          arch = "aarch64-darwin";
          extraModules = [
            homebrew.homeManagerModules.default
            ./modules/home-manager/hosts/seraphim
          ];
        }
        {
          hostname = "cherubim";
          arch = "x86_64-linux";
          extraModules = [
            ./modules/home-manager/hosts/cherubim
          ];
        }
      ];

      eachHmSystem = f: builtins.foldl' (a: b: a // b) { } (builtins.map f hmSystems);

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
          cherubim = nixpkgs.lib.nixosSystem {
            modules = [
              nixModule
              ./modules/nixos/hosts/cherubim
            ];
          };
        };

      homeConfigurations = eachHmSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system.arch};
        in
        {
          "bruno@${system.hostname}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              {
                nixpkgs = {
                  overlays = overlays;
                  config = {
                    allowUnfree = true;
                    permittedInsecurePackages = [
                      "openclaw-2026.4.11"
                    ];
                  };
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
