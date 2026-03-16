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
      systems = [
        {
          hostname = "solaire";
          arch = "aarch64-darwin";
        }
        {
          hostname = "artorias";
          arch = "x86_64-linux";
        }
      ];

      forAllSystems = f: builtins.foldl' (a: b: a // b) { } (builtins.map f systems);

      overlays = [
        neovim-nightly.overlays.default
      ];
    in
    {
      homeConfigurations = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system.arch};
        in
        {
          "bruno@${system.hostname}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              { nixpkgs.overlays = overlays; }
              homebrew.homeManagerModules.default
              ./home.nix
            ];
          };
        }
      );
    };
}
