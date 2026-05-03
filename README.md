# bfpimentel's dotfiles

## Introduction

This is a heavily opinionated and personal dotfiles repository using Nix and the Dendritic pattern.

It's intended to be fully reproducible, although I'm not ensuring anything.

Most app configuration lives in `dotfiles/` and is linked with Home Manager helpers from `modules/features/home/util.nix`.

## Hosts

- `seraphim`: Macbook Pro (`aarch64-darwin`) with Home Manager, Homebrew.
- `cherubim`: Linux desktop (`x86_64-linux`) with NixOS, Display Manager (Hyprland), Game streaming setup.
- `powers`: Linux mini PC (`x86_64-linux`) with NixOS, Hermes, containers.
- `thronos`: Linux OCI server (`aarch64-linux`) with NixOS, WIP.

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
        └── nixos              # NixOS boot, users, networking, display, secrets, services
            ├── hardware       # Host hardware definitions
            ├── hermes         # Hermes agent service and documents
            └── containers     # OCI declarative containers (podman)
```

## Design

The repository is organized around the `bfmp` topology:

```nix
bfmp = {
    nixos = {
        sharedModules = [];    # applies NixOS modules to every NixOS host.
        hosts = {
            <host> = {
                modules = [];  # adds host-specific NixOS modules.
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
