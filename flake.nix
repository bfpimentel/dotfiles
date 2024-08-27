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

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    );

    createNixOS = hostname: username: fullname: email: (
      let
        specialArgs = { inherit inputs outputs; } // {
	  inherit hostname username fullname email;
	  impurePaths.workingDir = "/etc/nixos";
	};
	modules = (builtins.attrValues nixosModules) ++ [
	  "/etc/nixos/nixos/${hostname}"
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users."${username}" = import ./home-manager/home.nix;
          }
        ];
      in nixpkgs.lib.nixosSystem {
        inherit specialArgs modules;    
      }
    );
  in {
    inherit legacyPackages;

    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

    overlays = import ./overlays { inherit inputs; };

    nixosConfigurations = {
      blackbox = createNixOS "blackbox" "bruno" "Bruno Pimentel" "hello@bruno.so";
    };
  };
}

