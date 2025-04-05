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
      # url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    textfox = {
      url = "github:adriankarlen/textfox";
    };
    neovim-nightly-overlay = {
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
      textfox,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      domain = "local.jalotopimentel.com";
      externalDomain = "external.jalotopimentel.com";

      buildHomeManagerConfig =
        hostname:
        let
          rootPath = "/etc/nixos/modules/home-manager";
          hostPath = "${rootPath}/hosts/${hostname}";
          sharedPath = "${rootPath}/shared";
        in
        {
          linkHostApp = config: app: config.lib.file.mkOutOfStoreSymlink "${hostPath}/${app}/config";
          linkSharedApp = config: app: config.lib.file.mkOutOfStoreSymlink "${sharedPath}/${app}/config";
        };

      createNixOS =
        system: hostname: username: fullname: email:
        (
          let
            commonVars = (
              import (./. + "/hosts/shared/vars.nix") {
                system = system;
                hostname = hostname;
                username = username;
                fullname = fullname;
                email = email;
                domain = domain;
                externalDomain = externalDomain;
              }
            );
            systemSpecificVars = (import (./. + "/hosts/${commonVars.hostname}/vars.nix"));
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

            modules = (builtins.attrValues nixosModules) ++ [
              (./. + "/hosts/${vars.hostname}")
              agenix.nixosModules.default
              impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${vars.defaultUser}" = homeManagerModules;
                home-manager.extraSpecialArgs = specialArgs // {
                  homeManagerConfig = buildHomeManagerConfig vars.hostname;
                };
              }
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
              import (./. + "/hosts/shared/vars.nix") {
                system = system;
                hostname = hostname;
                username = username;
                fullname = fullname;
                email = email;
                domain = domain;
                externalDomain = externalDomain;
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
            modules = (builtins.attrValues darwinModules) ++ [
              (./. + "/hosts/${hostname}")
              agenix.nixosModules.default
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${username}" = homeManagerModules;
                home-manager.extraSpecialArgs = specialArgs // {
                  homeManagerConfig = buildHomeManagerConfig hostname;
                };
              }
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
