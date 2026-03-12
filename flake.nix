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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      overlays = [
        neovim-nightly.overlays.default
      ];
    in
    {
      homeConfigurations."bruno" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          { nixpkgs.overlays = overlays; }
          homebrew.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
