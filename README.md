# bfpimentel's dotfiles

## Introduction

This is a heavily opinionated and personal dotfiles repository using Nix with the Dendritic pattern.

It's intended to be fully reproducible, although I'm not ensuring anything.

Most app configuration lives in `dotfiles/` and is linked with Home Manager helpers from `modules/features/home/util.nix`.

## Hosts

- `seraphim`: Nix Darwin Host (`aarch64-darwin`), Home Manager, Homebrew Casks.
- `cherubim`: NixOS Host (`x86_64-linux`), Hyprland, Game streaming setup (out of service)
- `powers`: NixOS Host (`x86_64-linux`), Wireguard client, Docker containers.
- `thronos`: NixOS Host (`aarch64-linux`), Wireguard server for tunneling local network.

## Structure

```text
.
├── flake.nix                  # Flake entry point; imports ./modules through flake-parts
├── dotfiles                   # App config sources linked into $HOME
├── secrets                    # agenix definitions and encrypted secrets
├── misc                       # Extra managed files, such as Vial layouts and wallpapers
└── modules
    ├── default.nix            # Auto-imports all Nix modules under the 'modules' folder
    ├── topology               # bfmp options and generated flake outputs
    └── features
        ├── home               # Home Manager users, packages, files, SSH, Neovim, Homebrew
        ├── darwin             # Darwin system config
        └── nixos              # NixOS boot, users, networking, display, secrets, services
            ├── hardware       # Host hardware definitions
            └── containers     # OCI declarative containers (docker)
```

Feature modules can also be moved into `archive` folders and they will not be resolved by the flake.

## Design

The repository is organized around the `bfmp` topology:

```nix
bfmp = {
    nixos = {
        sharedModules = [];    # applies modules to every nixos host.
        hosts = {
            <host> = {
                modules = [];  # adds host-specific nixos modules.
            }
        };
    };
    darwin = {
        sharedModules = [];    # applies modules to every nix-darwin host.
        hosts = {
            <host> = {
                modules = [];  # adds host-specific nix-darwin modules.
            }
        };
    };
    hm = {
        sharedModules = [];    # applies Home Manager modules to every home profile.
        hosts = {
            <host> = {
                modules = [];  # adds host-specific Home Manager modules.
            }
        };
    };
};
```
