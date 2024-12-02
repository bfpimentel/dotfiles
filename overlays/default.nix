{ inputs, pkgs, ... }:

{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    slirp4netns = prev.slirp4netns.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./patches/slirp4netns.patch ];
    });
    ollama = prev.ollama.overrideAttrs (oldAttrs: {
      cudaSupport = true;
      cudaCapabilities = [ "12.0" ];
    });
  };
}
