{
  description = "bfpimentel's dotfiles (dendritic)";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    # Nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utils
    flake-parts.url = "github:hercules-ci/flake-parts";
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    agenix.url = "github:ryantm/agenix";
    brew-api = {
      url = "github:bfpimentel/brew-api";
      flake = false;
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };

    # Apps
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    llm-agents.url = "github:numtide/llm-agents.nix";
    herdr.url = "github:ogulcancelik/herdr";
    halo.url = "github:bfpimentel/halo";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules
      ];
    };
}
