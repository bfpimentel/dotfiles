{
  description = "homelab flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nix-darwin,
      nix-homebrew,
      home-manager,
      agenix,
      impermanence,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      legacyPackages = import nixpkgs {
        config.allowUnfree = true;
      };

      overlays = import ./overlays { inherit inputs; };

      formatter = legacyPackages.nixpkgs-rfc-style;

      domain = "local.jalotopimentel.com";
      externalDomain = "jalotopimentel.com";

      mkUtil =
        hostname:
        import ./util.nix {
          hostname = hostname;
          domain = domain;
          lib = nixpkgs.config.lib;
        };

      createNixOS =
        hostname:
        (
          let
            commonVars = (
              import ./modules/shared/vars.nix {
                inherit
                  hostname
                  domain
                  externalDomain
                  ;
              }
            );
            vars = commonVars // (import ./modules/hosts/${commonVars.hostname}/vars.nix);

            specialArgs = {
              inherit
                inputs
                outputs
                vars
                ;
              util = mkUtil vars.hostname;
            };

            modules = [
              (import ./modules/hosts/${vars.hostname})
              (import ./modules/shared/nixos)
              (import ./modules/home-manager {
                inherit
                  inputs
                  hostname
                  specialArgs
                  ;
                username = vars.defaultUser;
              })
              home-manager.nixosModules.home-manager
              agenix.nixosModules.default
              impermanence.nixosModules.impermanence
            ];
          in
          {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
              inherit modules specialArgs;
            };
          }
        );

      createDarwin =
        hostname:
        (
          let
            vars = (
              import ./modules/shared/vars.nix {
                inherit
                  hostname
                  domain
                  externalDomain
                  ;
              }
            );
            specialArgs = {
              inherit
                inputs
                outputs
                vars
                ;
              util = mkUtil vars.hostname;
            };
            modules = [
              (import ./modules/hosts/${vars.hostname})
              (import ./modules/shared/darwin)
              (import ./modules/home-manager {
                inherit
                  inputs
                  hostname
                  specialArgs
                  ;
                username = vars.defaultUser;
              })
              home-manager.darwinModules.home-manager
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  user = vars.defaultUser;
                  enableRosetta = true;
                  autoMigrate = true;
                  # mutableTaps = false;
                };
              }
            ];
          in
          {
            name = hostname;
            value = nix-darwin.lib.darwinSystem {
              inherit specialArgs modules;
            };
          }
        );
    in
    {
      inherit legacyPackages overlays formatter;

      nixosConfigurations = builtins.listToAttrs [
        (createNixOS "malenia")
        (createNixOS "miquella")
      ];

      darwinConfigurations = builtins.listToAttrs [
        (createDarwin "solaire")
      ];

      darwinPackages = self.darwinConfigurations.${outputs.networking.hostName}.pkgs;
    };
}
