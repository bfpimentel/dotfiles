{ inputs, pkgs, ... }:

{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    kanata = inputs.nixpkgs-stable.legacyPackages.${prev.system}.kanata;
    karabiner-elements = inputs.nixpkgs-stable.legacyPackages.${prev.system}.karabiner-elements;
    slirp4netns = prev.slirp4netns.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./patches/slirp4netns.patch ];
    });
    ollama = prev.ollama.overrideAttrs (oldAttrs: {
      cudaSupport = true;
      cudaCapabilities = [ "12.0" ];
    });
  };
}
