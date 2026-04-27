{ lib, ... }:

let
  inherit (lib) mkOption;
  types = lib.types;
in
{
  options.bfmp = {
    user = mkOption {
      type = types.str;
      default = "bruno";
    };

    hm = {
      overlays = mkOption {
        type = types.listOf types.raw;
        default = [ ];
      };

      nixpkgsConfig = mkOption {
        type = types.attrs;
        default = { };
      };

      sharedModules = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
      };

      hosts = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              arch = mkOption {
                type = types.str;
              };

              modules = mkOption {
                type = types.listOf types.deferredModule;
                default = [ ];
              };
            };
          }
        );
        default = { };
      };
    };

    nixos = {
      commonModules = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
      };

      hosts = mkOption {
        type = types.attrsOf (
          types.submodule {
            options.modules = mkOption {
              type = types.listOf types.deferredModule;
              default = [ ];
            };
          }
        );
        default = { };
      };
    };
  };
}
