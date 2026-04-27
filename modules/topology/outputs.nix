{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.bfmp;
in
{
  flake = {
    homeConfigurations = lib.mapAttrs' (
      hostname: hostCfg:
      lib.nameValuePair "${cfg.user}@${hostname}" (
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${hostCfg.arch};

          modules =
            [
              {
                nixpkgs = {
                  overlays = cfg.hm.overlays;
                  config = cfg.hm.nixpkgsConfig;
                };
              }
            ]
            ++ cfg.hm.sharedModules
            ++ hostCfg.modules;
        }
      )
    ) cfg.hm.hosts;

    nixosConfigurations = lib.mapAttrs (
      _: hostCfg:
      inputs.nixpkgs.lib.nixosSystem {
        modules = cfg.nixos.commonModules ++ hostCfg.modules;
      }
    ) cfg.nixos.hosts;
  };
}
