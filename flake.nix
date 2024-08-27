{
  description = "homelab flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    nixpkgs-stable, 
    home-manager, 
    agenix,
    ... 
  }@ inputs: let
    inherit (self) outputs;
    
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );
  in {
    inherit legacyPackages nixosModules homeManagerModules;

    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = 
      let 
        defaultModules = (builtins.attrValues nixosModules) ++ [
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              bruno = import ./home-manager/home.nix;
	    }; 
          }
        ];
        specialArgs = { inherit inputs outputs; };
      in {
        blackbox = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = defaultModules ++ [ ./nixos/blackbox ];
        };
      };

    # homeConfigurations = {
    #   bruno = home-manager.lib.homeManagerConfiguration {
    #     pkgs = legacyPackages.x86_64-linux;
    #     extraSpecialArgs = { inherit inputs outputs; };
    #     modules = (builtins.attrValues homeManagerModules) ++ [
    #       ./home-manager/home.nix
    #     ];
    #   };
    # };
  };
}

