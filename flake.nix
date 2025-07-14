{
  description = "homelab flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.11";
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
    apollo = {
      url = "github:nil-andreas/apollo-flake";
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
      apollo,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      domain = "local.jalotopimentel.com";
      externalDomain = "external.jalotopimentel.com";

      createNixOS =
        system: hostname: username: fullname: email:
        (
          let
            commonVars = (
              import ./modules/shared/vars.nix {
                inherit
                  system
                  hostname
                  username
                  fullname
                  email
                  domain
                  externalDomain
                  ;
              }
            );
            systemSpecificVars = import ./modules/hosts/${commonVars.hostname}/vars.nix;
            vars = commonVars // systemSpecificVars;
            util = import ./util.nix {
              domain = domain;
              lib = nixpkgs.config.lib;
            };

            specialArgs = {
              inherit
                inputs
                outputs
                vars
                util
                ;
            };

            modules = [
              (import ./modules/hosts/${vars.hostname})
              (import ./modules/shared/nixos)
              agenix.nixosModules.default
              apollo.nixosModules.${system}.default
              impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              (import ./modules/home-manager { inherit username hostname specialArgs; })
            ];
          in
          nixpkgs.lib.nixosSystem {
            inherit system modules specialArgs;
          }
        );

      createDarwin =
        hostname: username: fullname: email:
        (
          let
            system = "aarch64-darwin";
            vars = (
              import ./modules/shared/vars.nix {
                inherit
                  system
                  hostname
                  username
                  fullname
                  email
                  domain
                  externalDomain
                  ;
              }
            );
            util = import ./util.nix {
              domain = domain;
              lib = nixpkgs.config.lib;
            };

            specialArgs = {
              inherit
                inputs
                outputs
                vars
                util
                ;
            };
            modules = [
              (import ./modules/hosts/${vars.hostname})
              (import ./modules/shared/darwin)
              home-manager.darwinModules.home-manager
              (import ./modules/home-manager { inherit username hostname specialArgs; })
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  user = username;
                  enableRosetta = true;
                  autoMigrate = true;
                  # mutableTaps = false;
                };
              }
            ];
          in
          nix-darwin.lib.darwinSystem {
            inherit specialArgs modules;

          }
        );
    in
    {
      inherit legacyPackages;

      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-rfc-style);

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        malenia = createNixOS "x86_64-linux" "malenia" "bruno" "Bruno Pimentel" "hello@bruno.so";
        miquella = createNixOS "aarch64-linux" "miquella" "bruno" "Bruno Pimentel" "hello@bruno.so";
      };

      darwinConfigurations = {
        solaire = createDarwin "solaire" "bruno" "Bruno Pimentel" "hello@bruno.so";
      };

      darwinPackages = self.darwinConfigurations.${outputs.networking.hostName}.pkgs;
    };
}
