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
      hostname: hostConfig:
      lib.nameValuePair "bruno@${hostname}" (
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${hostConfig.arch};

          modules = [
            {
              nixpkgs = {
                overlays = cfg.hm.overlays;
                config = {
                  allowUnfree = true;
                  permittedInsecurePackages = [
                    "openclaw-2026.4.11"
                  ];
                };
              };
            }
          ]
          ++ cfg.hm.sharedModules
          ++ hostConfig.modules;
        }
      )
    ) cfg.hm.hosts;

    nixosConfigurations = lib.mapAttrs (
      _: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        modules = cfg.nixos.sharedModules ++ hostConfig.modules;
      }
    ) cfg.nixos.hosts;
  };
}
